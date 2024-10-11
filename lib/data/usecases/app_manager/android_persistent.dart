import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class AndroidPersistent implements Persistent {
  final _platform = MethodChannel(Channels.persistent.name);

  @override
  Future<void> closeApp() async {
    try {
      if (Platform.isAndroid) {
        final result = await _platform.invokeMethod("closeApp");
        debugPrint(result);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> makeNotPersistent() async {
    try {
      if (Platform.isAndroid) {
        final result = await _platform.invokeMethod("notPersistApp");

        debugPrint((result));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> makePersistent() async {
    try {
      if (Platform.isAndroid) {
        final result = await _platform.invokeMethod("persistApp");

        debugPrint((result));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
