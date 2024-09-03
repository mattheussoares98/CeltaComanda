import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin BehaviorManager {
  final _platform = const MethodChannel('persistent_channel');

  Future<void> persistApp() async {
    try {
      final result = await _platform.invokeMethod("persistApp");

      debugPrint((result));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> notPersistApp() async {
    try {
      final result = await _platform.invokeMethod("notPersistApp");

      debugPrint((result));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> closeApp() async {
    try {
      Future.delayed(Duration.zero, () async {
        final result = await _platform.invokeMethod("closeApp");
        debugPrint(result);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
