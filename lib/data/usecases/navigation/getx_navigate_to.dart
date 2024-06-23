import 'package:get/get.dart';

import '../../../domain/usecases/navigation/navigation.dart';

class GetxNavigateTo implements NavigateTo {
  @override
  dynamic navigate({
    required String pageRoute,
    bool? clear = false,
    arguments,
  }) {
    if (clear == true) {
      return Get.offAllNamed(pageRoute, arguments: arguments);
    } else {
      return Get.toNamed(pageRoute, arguments: arguments);
    }
  }
}
