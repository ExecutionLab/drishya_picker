// ignore_for_file: always_use_package_imports

import 'dart:async';

import 'package:drishya_picker/src/animations/animations.dart';
import 'package:drishya_picker/src/camera/camera_view.dart';
import 'package:drishya_picker/src/playground/playground.dart';
import 'package:drishya_picker/src/slidable_panel/slidable_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../drishya_entity.dart';
import 'entities/gallery_setting.dart';
import 'entities/gallery_value.dart';
import 'repo/gallery_repository.dart';
import 'widgets/albums_page.dart';
import 'widgets/gallery_asset_selector.dart';
import 'widgets/gallery_controller_provider.dart';
import 'widgets/gallery_grid_view.dart';
import 'widgets/gallery_header.dart';

const _defaultMin = 0.37;

///
///
///
///
///
class GalleryViewWrapper extends StatefulWidget {
  ///
  const GalleryViewWrapper({
    Key? key,
    required this.child,
    this.controller,
  }) : super(key: key);

  ///
  final Widget child;

  ///
  final GalleryController? controller;

  @override
  State<GalleryViewWrapper> createState() => _GalleryViewWrapperState();
}

class _GalleryViewWrapperState extends State<GalleryViewWrapper> {
  late GalleryController _controller;
  late final PanelController _panelController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? GalleryController();
    _panelController = _controller._panelController;
  }

  @override
  Widget build(BuildContext context) {
    final ps = _controller.panelSetting;
    final _panelMaxHeight = ps.maxHeight ??
        MediaQuery.of(context).size.height - (ps.topMargin ?? 0.0);
    final _panelMinHeight = ps.minHeight ?? _panelMaxHeight * _defaultMin;
    final _setting =
        ps.copyWith(maxHeight: _panelMaxHeight, minHeight: _panelMinHeight);

    final showPanel = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Material(
      key: _controller._wrapperKey,
      child: GalleryControllerProvider(
        controller: _controller,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Parent view
            Column(
              children: [
                //
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      final focusNode = FocusScope.of(context);
                      if (focusNode.hasFocus) {
                        focusNode.unfocus();
                      }
                      if (_panelController.isVisible) {
                        _controller._closePanel();
                      }
                    },
                    child: Builder(builder: (_) => widget.child),
                  ),
                ),

                // Space for panel min height
                ValueListenableBuilder<bool>(
                  valueListenable: _panelController.panelVisibility,
                  builder: (context, isVisible, child) {
                    return SizedBox(
                      height: showPanel && isVisible ? _panelMinHeight : 0.0,
                    );
                  },
                ),

                //
              ],
            ),

            // Gallery
            SlidablePanel(
              setting: _setting,
              controller: _panelController,
              child: Builder(
                builder: (_) => GalleryView(controller: _controller),
              ),
            ),

            //
          ],
        ),
      ),
    );

    //
  }
}

///
///
///
///
class GalleryView extends StatefulWidget {
  ///
  const GalleryView({
    Key? key,
    this.controller,
  }) : super(key: key);

  ///
  final GalleryController? controller;

  ///
  static const String name = 'GalleryView';

  ///
  static Future<List<DrishyaEntity>?> pick(BuildContext context) {
    return Navigator.of(context).push<List<DrishyaEntity>>(
      SlideTransitionPageRoute(
        builder: const GalleryView(),
        transitionCurve: Curves.easeIn,
        settings: const RouteSettings(name: name),
      ),
    );
  }

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView>
    with SingleTickerProviderStateMixin {
  late final GalleryController _controller;
  late final PanelController _panelController;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  double albumHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? GalleryController();

    _panelController = _controller._panelController;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 300),
      value: 0,
    );

    // ignore: prefer_int_literals
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  void _toogleAlbumList(bool isVisible) {
    if (_animationController.isAnimating) return;
    _controller._setAlbumVisibility(!isVisible);
    _panelController.isGestureEnabled = _animationController.value == 1.0;
    if (_animationController.value == 1.0) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  //
  void _showAlert() {
    final cancel = TextButton(
      onPressed: Navigator.of(context).pop,
      child: Text(
        'CANCEL',
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Colors.lightBlue,
            ),
      ),
    );
    final unselectItems = TextButton(
      onPressed: _onSelectionClear,
      child: Text(
        'USELECT ITEMS',
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Colors.blue,
            ),
      ),
    );

    final alertDialog = AlertDialog(
      title: Text(
        'Unselect these items?',
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.white70,
            ),
      ),
      content: Text(
        'Going back will undo the selections you made.',
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: Colors.grey.shade600,
            ),
      ),
      actions: [cancel, unselectItems],
      backgroundColor: Colors.grey.shade900,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
    );

    showDialog<void>(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  Future<bool> _onClosePressed() async {
    if (_animationController.isAnimating) return false;

    if (_controller._albumVisibility.value) {
      _toogleAlbumList(true);
      return false;
    }

    if (_controller.value.selectedEntities.isNotEmpty) {
      _showAlert();
      return false;
    }

    if (_controller.fullScreenMode) {
      Navigator.of(context).pop();
      return true;
    }

    final isPanelMax = _panelController.value.state == SlidingState.max;

    if (!_controller.fullScreenMode && isPanelMax) {
      _controller._panelController.minimizePanel();
      return false;
    }

    return true;
  }

  void _onSelectionClear() {
    _controller._clearSelection();
    Navigator.of(context).pop();
  }

  void _onALbumChange(Album album) {
    if (_animationController.isAnimating) return;
    _controller._albums.changeAlbum(album);
    _toogleAlbumList(true);
  }

  @override
  Widget build(BuildContext context) {
    final ps = _controller.panelSetting;
    final _panelMaxHeight = ps.maxHeight ??
        MediaQuery.of(context).size.height - (ps.topMargin ?? 0.0);
    final _panelMinHeight = ps.minHeight ?? _panelMaxHeight * _defaultMin;
    final _setting =
        ps.copyWith(maxHeight: _panelMaxHeight, minHeight: _panelMinHeight);

    final albumListHeight = _panelMaxHeight - ps.headerMaxHeight;
    albumHeight = albumListHeight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _setting.overlayStyle,
      child: WillPopScope(
        onWillPop: _onClosePressed,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            // fit: StackFit.expand,
            children: [
              // Header
              Align(
                alignment: Alignment.topCenter,
                child: GalleryHeader(
                  controller: _controller,
                  albums: _controller._albums,
                  onClose: _onClosePressed,
                  onAlbumToggle: _toogleAlbumList,
                  albumVisibility: _controller._albumVisibility,
                ),
              ),

              // Body
              Column(
                children: [
                  // Header space
                  Builder(
                    builder: (context) {
                      if (_controller.fullScreenMode) {
                        return SizedBox(height: _setting.headerMaxHeight);
                      }

                      return ValueListenableBuilder<SliderValue>(
                        valueListenable: _panelController,
                        builder: (context, SliderValue value, child) {
                          final height = (_setting.headerMinHeight +
                                  (_setting.headerMaxHeight -
                                          _setting.headerMinHeight) *
                                      value.factor *
                                      1.2)
                              .clamp(
                            _setting.headerMinHeight,
                            _setting.headerMaxHeight,
                          );
                          return SizedBox(height: height);
                        },
                      );
//
                    },
                  ),

                  // Divider
                  Divider(
                    color: Colors.lightBlue.shade300,
                    thickness: 0.3,
                    height: 2,
                  ),

                  // Gallery grid
                  Expanded(
                    child: GalleryGridView(
                      controller: _controller,
                      albums: _controller._albums,
                      panelController: _controller._panelController,
                      onCameraRequest: _controller._openCamera,
                      onSelect: _controller._select,
                    ),
                  ),
                ],
              ),

              // Send and edit button
              GalleryAssetSelector(
                controller: _controller,
                onEdit: (e) {
                  _controller._openPlayground(context, e);
                },
                onSubmit: _controller._completeTask,
              ),

              // Album list
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final offsetY = _setting.headerMaxHeight +
                      (_panelMaxHeight - ps.headerMaxHeight) *
                          (1 - _animation.value);
                  return Visibility(
                    visible: _animation.value > 0.0,
                    child: Transform.translate(
                      offset: Offset(0, offsetY),
                      child: child,
                    ),
                  );
                },
                child: AlbumsPage(
                  albums: _controller._albums,
                  controller: _controller,
                  onAlbumChange: _onALbumChange,
                ),
              ),

              //
            ],
          ),
        ),
      ),
    );
  }
}

///
///
///
///
///
///
class GalleryViewField extends StatefulWidget {
  ///
  /// Widget which pick media from gallery
  ///
  /// If used [GalleryViewField] with [GalleryViewWrapper], [PanelSetting]
  /// and [GallerySetting] will be override by the [GalleryViewWrapper]
  ///
  const GalleryViewField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.selectedEntities,
    this.panelSetting,
    this.gallerySetting,
    this.child,
  }) : super(key: key);

  ///
  /// While picking drishya using gallery removed will be true if,
  /// previously selected drishya is unselected otherwise false.
  ///
  final void Function(DrishyaEntity entity, bool removed)? onChanged;

  ///
  /// Triggered when picker complet its task.
  ///
  final void Function(List<DrishyaEntity> entities)? onSubmitted;

  ///
  /// Pre selected entities
  ///
  final List<DrishyaEntity>? selectedEntities;

  ///
  /// If used [GalleryViewField] with [GalleryViewWrapper]
  /// this setting will be ignored.
  ///
  /// [PanelSetting] passed to the [GalleryViewWrapper] will be applicable..
  ///
  final PanelSetting? panelSetting;

  ///
  /// If used [GalleryViewField] with [GalleryViewWrapper]
  /// this setting will be ignored.
  ///
  /// [GallerySetting] passed to the [GalleryViewWrapper] will be applicable..
  ///
  final GallerySetting? gallerySetting;

  ///
  final Widget? child;

  @override
  State<GalleryViewField> createState() => _GalleryViewFieldState();
}

class _GalleryViewFieldState extends State<GalleryViewField> {
  late GalleryController _controller;
  bool _dispose = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(_init);
  }

  void _init(Duration timeStamp) {
    if (context.galleryController == null) {
      _controller = GalleryController(
        panelSetting: widget.panelSetting,
        gallerySetting: widget.gallerySetting,
      );
      _dispose = true;
    } else {
      _controller = context.galleryController!;
    }
  }

  @override
  void dispose() {
    if (_dispose) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller._openGallery(
          widget.onChanged,
          widget.onSubmitted,
          widget.selectedEntities,
          context,
        );
      },
      child: widget.child,
    );
  }
}

///
///
///
///
///
///
class GalleryController extends ValueNotifier<GalleryValue> {
  ///
  /// Drishya controller
  GalleryController({
    PanelSetting? panelSetting,
    GallerySetting? gallerySetting,
  })  : panelSetting = panelSetting ?? const PanelSetting(),
        setting = gallerySetting ?? const GallerySetting(),
        _panelController = PanelController(),
        _albumVisibility = ValueNotifier(false),
        super(const GalleryValue()) {
    _albums = Albums()..fetchAlbums(setting.requestType);
  }

  /// Panel setting
  final PanelSetting panelSetting;

  /// Media setting
  late final GallerySetting setting;

  /// Panel controller
  final PanelController _panelController;

  /// Drishya repository
  late final Albums _albums;

  /// Recent entities notifier
  final ValueNotifier<bool> _albumVisibility;

  // Completer for gallerry picker controller
  late Completer<List<DrishyaEntity>> _completer;

  // Flag to handle updating controller value internally
  var _internal = false;

  // Flag for handling when user cleared all selected medias
  var _clearedSelection = false;

  // Gallery picker on changed event callback handler
  void Function(DrishyaEntity entity, bool removed)? _onChanged;

  //  Gallery picker on submitted event callback handler
  void Function(List<DrishyaEntity> entities)? _onSubmitted;

  // Full screen mode or collapsable mode
  var _fullScreenMode = false;

  var _accessCamera = false;

  final _wrapperKey = GlobalKey();

  ///
  void _setAlbumVisibility(bool visible) {
    _panelController.isGestureEnabled = !visible;
    _albumVisibility.value = visible;
  }

  /// Clear selected entities
  void _clearSelection() {
    _onSubmitted?.call([]);
    _clearedSelection = true;
    _internal = true;
    value = const GalleryValue();
  }

  /// Selecting and unselecting entities
  void _select(DrishyaEntity entity, BuildContext context) {
    if (singleSelection) {
      _onChanged?.call(entity, false);
      _completeTask(context, [entity]);
    } else {
      _clearedSelection = false;
      final selectedList = value.selectedEntities.toList();
      if (selectedList.contains(entity)) {
        selectedList.remove(entity);
        _onChanged?.call(entity, true);
      } else {
        if (reachedMaximumLimit) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  'Maximum selection limit of '
                  '${setting.maximum} has been reached!',
                ),
              ),
            );
          return;
        }
        selectedList.add(entity);
        _onChanged?.call(entity, false);
      }
      _internal = true;
      value = value.copyWith(
        selectedEntities: selectedList,
        previousSelection: false,
      );
    }
  }

  /// When selection is completed
  void _completeTask(BuildContext context, List<DrishyaEntity>? entities) {
    if (_fullScreenMode) {
      Navigator.of(context).pop(entities);
    } else {
      _panelController.closePanel();
      // _checkKeyboard.value = false;
    }
    _onSubmitted?.call(entities ?? []);
    _completer.complete(entities ?? []);
    _internal = true;
    value = const GalleryValue();
  }

  /// When panel closed without any selection
  void _closePanel() {
    _panelController.closePanel();
    final entities = (_clearedSelection || value.selectedEntities.isEmpty)
        ? <DrishyaEntity>[]
        : value.selectedEntities;
    _completer.complete(entities);
    // _onSubmitted?.call(entities);
    // _checkKeyboard.value = false;
    _internal = true;
    value = const GalleryValue();
  }

  /// Close collapsable panel if camera is selected from inside gallery view
  void _closeOnCameraSelect() {
    _panelController.closePanel();
    // _checkKeyboard.value = false;
    _internal = true;
    value = const GalleryValue();
  }

  /// Open camera from [GalleryView]
  Future<void> _openCamera(BuildContext context) async {
    _accessCamera = true;
    DrishyaEntity? entity;

    final route = SlideTransitionPageRoute<DrishyaEntity>(
      builder: const CameraView(),
      begainHorizontal: true,
      transitionDuration: const Duration(milliseconds: 300),
    );

    if (fullScreenMode) {
      entity = await Navigator.of(context).pushReplacement(route);
    } else {
      entity = await Navigator.of(context).push(route);
      _closeOnCameraSelect();
    }

    final entities = [...value.selectedEntities];
    if (entity != null) {
      entities.add(entity);
      _onChanged?.call(entity, false);
      _onSubmitted?.call(entities);
    }
    _accessCamera = false;
    _completer.complete(entities);
  }

  /// Open camera from [GalleryView]
  Future<void> _openPlayground(
    BuildContext context,
    DrishyaEntity entity,
  ) async {
    _select(entity, context);
    _accessCamera = true;
    DrishyaEntity? pickedEntity;

    final bytes = await entity.originBytes;

    final route = SlideTransitionPageRoute<DrishyaEntity>(
      builder: Playground(
        background: PhotoBackground(bytes: bytes),
        enableOverlay: true,
      ),
      begainHorizontal: true,
      transitionDuration: const Duration(milliseconds: 300),
    );

    if (fullScreenMode) {
      // ignore: use_build_context_synchronously
      pickedEntity = await Navigator.of(context).pushReplacement(route);
    } else {
      // ignore: use_build_context_synchronously
      pickedEntity = await Navigator.of(context).push(route);
      _closeOnCameraSelect();
    }

    final entities = [...value.selectedEntities];
    if (pickedEntity != null) {
      entities.add(pickedEntity);
      _onChanged?.call(pickedEntity, false);
      _onSubmitted?.call(entities);
    }
    _accessCamera = false;
    _completer.complete(entities);
  }

  /// Open gallery using [GalleryViewField]
  void _openGallery(
    void Function(DrishyaEntity entity, bool removed)? onChanged,
    final void Function(List<DrishyaEntity> entities)? onSubmitted,
    List<DrishyaEntity>? selectedEntities,
    BuildContext context,
  ) {
    _onChanged = onChanged;
    _onSubmitted = onSubmitted;
    pick(context, selectedEntities: selectedEntities);
  }

  // ===================== PUBLIC ==========================

  /// Pick assets
  Future<List<DrishyaEntity>> pick(
    BuildContext context, {
    List<DrishyaEntity>? selectedEntities,
  }) async {
    // If dont have permission dont do anything
    final permission = await PhotoManager.requestPermissionExtend();
    if (permission != PermissionState.authorized &&
        permission != PermissionState.limited) {
      PhotoManager.openSetting();
      return [];
    }

    _completer = Completer<List<DrishyaEntity>>();

    if (_wrapperKey.currentState == null) {
      _fullScreenMode = true;
      final route = SlideTransitionPageRoute<List<DrishyaEntity>>(
        builder: GalleryView(controller: this),
      );

      // ignore: use_build_context_synchronously
      await Navigator.of(context).push(route).then((result) {
        // Closed by user
        if (result == null && !_accessCamera) {
          _completer.complete(value.selectedEntities);
        }
      });
    } else {
      _fullScreenMode = false;
      _panelController.openPanel();
      // ignore: use_build_context_synchronously
      FocusScope.of(context).unfocus();
    }
    if (!singleSelection && (selectedEntities?.isNotEmpty ?? false)) {
      _internal = true;
      value = value.copyWith(
        selectedEntities: selectedEntities,
        previousSelection: true,
      );
    }

    return _completer.future;
  }

  // ===================== GETTERS ==========================

  ///
  /// Recent entities list
  ///
  Future<List<DrishyaEntity>> recentEntities({
    RequestType? type,
    int count = 20,
  }) =>
      _albums.recentEntities(type: type, count: count);

  ///
  /// return true if gallery is in full screen mode,
  ///
  bool get fullScreenMode => _fullScreenMode;

  ///
  /// return true if selected media reached to maximum selection limit
  ///
  bool get reachedMaximumLimit =>
      value.selectedEntities.length == setting.maximum;

  ///
  /// return true is gallery is in single selection mode
  ///
  bool get singleSelection => setting.maximum == 1;

  @override
  set value(GalleryValue newValue) {
    if (_internal) {
      super.value = newValue;
      _internal = false;
    }
  }

  @override
  void dispose() {
    _panelController.dispose();
    _albums.dispose();
    _albumVisibility.dispose();
    super.dispose();
  }

  //
}
