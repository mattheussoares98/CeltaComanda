import 'dart:io';

import '../../../domain/usecases/usecases.dart';

class FlutterGetPlatform implements GetPlataform {
  @override
  bool isWeb() {
    try {
      //TODO 
      //use a package to get if is web
      return !Platform.isAndroid && !Platform.isIOS && !Platform.isWindows;
    } catch (e) {
      return true;
    }
  }
}
