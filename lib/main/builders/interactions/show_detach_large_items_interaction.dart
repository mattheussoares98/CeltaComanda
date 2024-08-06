import 'dart:async';

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/pages/pages.dart';
import '../builders.dart';

class ShowDetachLargeItemsInteraction {
  static MenuPresenter menuPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );
  static const _duration = Duration(seconds: 300);
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
    _timer.cancel();
    if (!_hasDetachGroup(menuPresenter)) {
      return;
    }

    showDialog(
      context: NavigatorKey.navigatorKey.currentState!.context,
      builder: (context) {
        return Stack(
          children: [
            AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              insetPadding: const EdgeInsets.all(0),
              content: SizedBox(
                height: MediaQuery.of(
                        NavigatorKey.navigatorKey.currentState!.context)
                    .size
                    .height,
                width: MediaQuery.of(
                        NavigatorKey.navigatorKey.currentState!.context)
                    .size
                    .width,
                child: DetachItems(
                  popOnImageClick: true,
                  products: menuPresenter.loadedMenu[0].entries.first.value,
                ),
              ),
            ),
            Positioned(
              top: hasMinWidth(context) ? 30 : 5,
              right: hasMinWidth(context) ? 30 : 5,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minRadius: hasMinWidth(context) ? 40 : 20,
                  maxRadius: hasMinWidth(context) ? 40 : 20,
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.close,
                        size: hasMinWidth(context) ? 100 : 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    _timer.cancel();
  }

  static void restartTime() {
    _timer.cancel();
    _timer = Timer.periodic(_duration, (_) => _showLargeDetachItems());
  }
}
