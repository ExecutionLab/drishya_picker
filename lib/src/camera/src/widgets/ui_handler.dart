import 'dart:async';

import 'package:camera/camera.dart';
import 'package:drishya_picker/src/animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
class UIHandler {
  ///
  UIHandler._internal(this._context);

  ///
  factory UIHandler.of(BuildContext context) => UIHandler._internal(context);

  ///
  final BuildContext _context;

  /// Navigator state for the [_context]
  NavigatorState get _state => Navigator.of(_context);

  /// Internal navigation translation handlation
  static TransitionFrom? transformFrom;

  /// Hide status bar
  static Future<void> hideStatusBar() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  /// Show status bar
  static Future<void> showStatusBar() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Snackbar for error
  void showExceptionSnackbar(CameraException e) {
    ScaffoldMessenger.of(_context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
  }

  /// Snackbar for normal mesages
  void showSnackBar(String message) {
    ScaffoldMessenger.of(_context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Pop widget
  void pop<T extends Object?>([T? result]) {
    if (!_state.mounted) return;
    _state.pop<T?>(result);
  }

  /// Push widget
  Future<T?> push<T extends Object?>(Route<T> route) async {
    if (!_state.mounted) return null;
    return _state.push(route);
  }
}
