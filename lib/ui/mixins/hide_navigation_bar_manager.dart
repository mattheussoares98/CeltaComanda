import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
import 'package:flutter/services.dart';

import '../pages/home/home.dart';

mixin HideNavigationBarManager {
  void hideNavigationBar(HomePresenter homePresenter) {
    if (activePlatform == AppPlatform.tablet) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    }
  }
}
