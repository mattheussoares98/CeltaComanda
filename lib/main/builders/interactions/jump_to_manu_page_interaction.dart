import 'dart:async';

import 'package:flutter/material.dart';
import '../builders.dart';

class JumpToManuPageInteraction {
  static const timerJumpToMenuPage = Duration(seconds: 20);

  static Timer _timerToNavigateToMenuPage =
      Timer.periodic(timerJumpToMenuPage, (_) => _jumpToMenuPage(null));

  static void restartTime(PageController? pageController) {
    _timerToNavigateToMenuPage = Timer.periodic(
        timerJumpToMenuPage, (_) => _jumpToMenuPage(pageController));
  }

  static void _jumpToMenuPage(PageController? pageController) {
    Navigator.of(NavigatorKey.navigatorKey.currentState!.context)
        .popUntil((route) => route.isFirst);

    if (pageController != null) {
      pageController.jumpToPage(0);
      _timerToNavigateToMenuPage.cancel();
    }
  }

  static void cancelTime() {
    _timerToNavigateToMenuPage.cancel();
  }
}
