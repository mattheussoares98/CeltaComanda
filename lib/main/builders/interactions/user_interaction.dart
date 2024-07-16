import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../builders.dart';
import '../../../ui/pages/pages.dart';

class UserInteraction {
  UserInteraction._();

  static CartPresenter cartPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );
  static MenuPresenter menuPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );

  static void cancelTimes() {
    CartNotEmptyInteraction.cancelTime();
    JumpToManuPageInteraction.cancelTime();
    ShowDetachLargeItemsInteraction.cancelTime();
  }

  static void handleHomeInteraction([PageController? pageController]) {
    cancelTimes();

    CartNotEmptyInteraction.restartTime(pageController);
    JumpToManuPageInteraction.restartTime(pageController);
    ShowDetachLargeItemsInteraction.restartTime();
  }
}
