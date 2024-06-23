import 'package:get/get.dart';

import '../../../domain/usecases/navigation/navigation.dart';

class GetxNavigateTo implements NavigateTo {
  @override
  Future<dynamic> navigate({
    required String pageRoute,
    bool? clear = false,
    arguments,
  }) async {
    if (clear == true) {
      return await Get.offAllNamed(pageRoute, arguments: arguments);
    } else {
      return await Get.toNamed(pageRoute, arguments: arguments);
    }
  }
}
