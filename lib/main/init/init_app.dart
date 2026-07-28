import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
// [WAKELOCK-ACTIVE-START]
import 'package:wakelock_plus/wakelock_plus.dart';
// [WAKELOCK-ACTIVE-END]

import '../../firebase_options.dart';
import '../../infra/helpers/helpers.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  _deletePath();
  await initFirebase();
  await _initHive();
  _hideNavigationButtons();
// [WAKELOCK-ACTIVE-START]
  WakelockPlus.enable();
// [WAKELOCK-ACTIVE-END]
}

Future<void> initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: Platform.isIOS ? null : DefaultFirebaseOptions.currentPlatform,
    );

    if (Platform.isWindows) {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: false,
      );
    }
  }
}

void _deletePath() {
  try {
    if (kIsWeb || !Platform.isWindows) return;

    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null) return;

    final separator = Platform.pathSeparator;
    final pathToDelete = '$localAppData${separator}firestore';
    final directoryToDelete = Directory(pathToDelete);
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
