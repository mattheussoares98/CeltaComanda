import 'dart:async';

import 'package:provider/provider.dart';

import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../builders.dart';

class ShowDetachLargeItemsInteraction {
  static MenuPresenter menuPresenter = Provider.of(
    NavigatorKey.key.currentState!.context,
    listen: false,
  );
  static const _duration = Duration(seconds: 300);
  static Timer _timer =
      Timer.periodic(_duration, (_) => _showLargeDetachItems());

  static bool _hasDetachGroup(MenuPresenter menuPresenter) {
    for (var menu in menuPresenter.loadedMenu) {
      if (menu.expansibleGroupsViewModel.Name.toLowerCase() ==
          R.string.detach.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  static void _showLargeDetachItems() {
    _timer.cancel();
    if (!_hasDetachGroup(menuPresenter)) {
      return;
    }

    menuPresenter.updateIndexOfSelectedGroup(0);

    _timer.cancel();
  }

  static void restartTime() {
    _timer.cancel();
    _timer = Timer.periodic(_duration, (_) => _showLargeDetachItems());
  }
}
