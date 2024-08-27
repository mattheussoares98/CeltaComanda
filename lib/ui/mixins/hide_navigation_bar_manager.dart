import 'package:flutter/services.dart';

import '../pages/home/home.dart';

mixin HideNavigationBarManager {
  void hideNavigationBar(HomePresenter homePresenter) {
    if (homePresenter.isGeneratingVersionToTablet) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    }
  }
}
