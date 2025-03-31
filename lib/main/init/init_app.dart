import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../firebase_options.dart';
import '../../infra/helpers/helpers.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initFirebase();
  await _initHive();
  _hideNavigationButtons();
  WakelockPlus.enable();
  _deletePath("AppData\\Local\\firestore");
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
      options: Platform.isIOS ? null : DefaultFirebaseOptions.currentPlatform);
}

void _deletePath(String path) {
  if (kIsWeb || !Platform.isWindows) return;

  final userHome =
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  final pathToDelete = '$userHome/$path';
  final directoryToDelete = Directory(pathToDelete);

  try {
    if (directoryToDelete.existsSync()) {
      directoryToDelete.deleteSync(recursive: true);
    }
  } catch (e) {
    // debugPrint(e.toString());
  }
}

void _hideNavigationButtons() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

Future<void> _initHive() async {
  String? path;

  try {
    if (kIsWeb) {
      path = CacheKeys.hiveBoxName.name;
    } else {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      path = appDocumentDir.path;
    }
    Hive.init(path);
    await Hive.openBox(CacheKeys.hiveBoxName.name);
  } catch (e) {
    debugPrint(e.toString());
  }
}
