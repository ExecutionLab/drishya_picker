import 'dart:io';

import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget to display [DrishyaEntity] thumbnail
class EntityThumbnail extends StatefulWidget {
  ///
  const EntityThumbnail({
    Key? key,
    required this.entity,
    this.onBytesGenerated,
  }) : super(key: key);

  ///
  final DrishyaEntity entity;

  /// Callback function triggered when image bytes is generated
  final ValueSetter<Uint8List?>? onBytesGenerated;

  @override
  State<EntityThumbnail> createState() => _EntityThumbnailState();
}

class _EntityThumbnailState extends State<EntityThumbnail> with AutomaticKeepAliveClientMixin {
  File? file;

  @override
  void initState() {
    super.initState();
    widget.entity.file.then((value) => setState(() => file = value));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget child = const SizedBox();

    //
    if (widget.entity.type == AssetType.image || widget.entity.type == AssetType.video) {
      if (widget.entity.pickedThumbData != null) {
        child = Image.memory(
          widget.entity.pickedThumbData!,
          fit: BoxFit.cover,
        );
      } else {
        child = AssetEntityImage(
          widget.entity.entity,
          isOriginal: false,
          thumbnailSize: const ThumbnailSize.square(300),
          fit: BoxFit.cover,
        );
      }
    }

    if (widget.entity.type == AssetType.audio) {
      child = const Center(child: Icon(Icons.audiotrack, color: Colors.white));
    }

    if (widget.entity.type == AssetType.other) {
      child = const Center(child: Icon(Icons.file_copy, color: Colors.white));
    }

    if (widget.entity.type == AssetType.video || widget.entity.type == AssetType.audio) {
      child = Stack(
        fit: StackFit.expand,
        children: [
          child,
          Align(
            alignment: Alignment.bottomRight,
            child: _DurationView(duration: widget.entity.duration),
          ),
        ],
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: child,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _DurationView extends StatelessWidget {
  const _DurationView({
    Key? key,
    required this.duration,
  }) : super(key: key);

  final int duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.7),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          duration.formatedDuration,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

extension on int {
  String get formatedDuration {
    final duration = Duration(seconds: this);
    final min = duration.inMinutes.remainder(60).toString().padRight(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
