import 'package:get/get.dart';

import '../../../domain/usecases/navigation/navigation.dart';

class GetxNavigateTo implements NavigateTo {
  @override
  void navigate({
    required String pageRoute,
    bool? clear = false,
    arguments,
  }) {
    if (clear == true) {
      Get.offAllNamed(pageRoute, arguments: arguments);
    } else {
      Get.toNamed(pageRoute, arguments: arguments);
    }
  }
}
