import 'package:get/get.dart';

mixin NavigationManager {
  void handleNavigation(Stream<String?> stream,
      {bool clear = false, dynamic arguments}) {
    stream.listen((page) {
      if (page != null && page.isNotEmpty) {
        if (clear == true) {
          Get.offAllNamed(page, arguments: arguments);
        } else {
          Get.toNamed(page, arguments: arguments);
        }
      }
    });
  }
}
