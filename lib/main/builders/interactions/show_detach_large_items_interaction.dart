import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/pages/pages.dart';
import '../builders.dart';

class ShowDetachLargeItemsInteraction {
  static MenuPresenter menuPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );
  static const _duration = Duration(seconds: 20);
  static Timer _timer =
      Timer.periodic(_duration, (_) => _showLargeDetachItems());

  static bool _hasDetachGroup(MenuPresenter menuPresenter) {
    for (var menu in menuPresenter.loadedMenu) {
      for (var group in menu.keys) {
        if (group.Name.toLowerCase() == "destaques") {
          return true;
        }
      }
    }
    return false;
  }

  static void _showLargeDetachItems() {
    if (!_hasDetachGroup(menuPresenter)) {
      return;
    }

    showDialog(
      context: NavigatorKey.navigatorKey.currentState!.context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            insetPadding: const EdgeInsets.all(0),
            content: SizedBox(
              height:
                  MediaQuery.of(NavigatorKey.navigatorKey.currentState!.context)
                      .size
                      .height,
              width:
                  MediaQuery.of(NavigatorKey.navigatorKey.currentState!.context)
                      .size
                      .width,
              child: DetachItems(
                showLargeImageOnTap: false,
                products: menuPresenter.loadedMenu[0].entries.first.value,
              ),
            ),
          ),
        );
      },
    );

    _timer.cancel();
  }

  static void restartTime() {
    _timer = Timer.periodic(_duration, (_) => _showLargeDetachItems());
  }

  static void cancelTime() {
    _timer.cancel();
  }
}
