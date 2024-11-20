import 'dart:io';

import '../../../domain/usecases/usecases.dart';

class FlutterGetPlatform implements GetPlataform {
  @override
  bool isWeb() {
    return !Platform.isAndroid && !Platform.isIOS && !Platform.isWindows;
  }
}
