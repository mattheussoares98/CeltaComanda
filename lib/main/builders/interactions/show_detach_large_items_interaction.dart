import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import '../builders.dart';

class ShowDetachLargeItemsInteraction {
  static MenuPresenter menuPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );

  static const timerShowLargeDetachItems = Duration(seconds: 30);

  static Timer _timerToShowLargeDetachItems =
      Timer.periodic(timerShowLargeDetachItems, (_) => _showLargeDetachItems());

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

    _timerToShowLargeDetachItems.cancel();
  }

  static void restartTime() {
    _timerToShowLargeDetachItems = Timer.periodic(
        timerShowLargeDetachItems, (_) => _showLargeDetachItems());
  }

  static void showCartNotEmptyMessage(PageController? pageController) {
    CartPresenter cartPresenter = Provider.of(
      NavigatorKey.navigatorKey.currentState!.context,
      listen: false,
    );

    if (pageController != null) {
      pageController.jumpToPage(1);
    }

    if (cartPresenter.confirmedCombox.isNotEmpty ||
        cartPresenter.cartProducts.isNotEmpty) {
      showErrorMessage(
        NavigatorKey.navigatorKey.currentState!.context,
        "Há produtos no carrinho que não foram enviados ainda. Pode ser que você tenha esquecido de enviar",
        duration: const Duration(seconds: 6),
      );
    }

    cancelTime();

    Navigator.of(NavigatorKey.navigatorKey.currentState!.context)
        .popUntil((route) => route.isFirst);
  }

  static void cancelTime() {
    _timerToShowLargeDetachItems.cancel();
  }
}
