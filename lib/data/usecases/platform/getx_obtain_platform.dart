import 'package:get/get.dart';

import '../../../domain/usecases/usecases.dart';
import '../../mixins/mixins.dart';

class GetxObtainPlatform with ErrorHandling implements ObtainPlataform {
  @override
  bool isWeb() {
    try {
      return GetPlatform.isWeb;
    } catch (e) {
      treatError(e);
    }
  }
}
