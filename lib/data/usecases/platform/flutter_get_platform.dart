import 'package:get/get.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class FlutterGetPlatform implements GetPlataform {
  @override
  bool isWeb() {
    try {
      return GetPlatform.isWeb;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
