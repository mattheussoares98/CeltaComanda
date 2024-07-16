import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import '../builders.dart';

class CartNotEmptyInteraction {
  static const timerShowMessageCartNotEmpty = Duration(seconds: 10);

  static Timer _timerToShowMessageCartNotEmpty = Timer.periodic(
      timerShowMessageCartNotEmpty, (_) => showCartNotEmptyMessage(null));

  static void restartTime(PageController? pageController) {
    _timerToShowMessageCartNotEmpty = Timer.periodic(
        timerShowMessageCartNotEmpty,
        (_) => showCartNotEmptyMessage(pageController));
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
    _timerToShowMessageCartNotEmpty.cancel();

    Navigator.of(NavigatorKey.navigatorKey.currentState!.context)
        .popUntil((route) => route.isFirst);
  }

  static void cancelTime() {
    _timerToShowMessageCartNotEmpty.cancel();
  }
}
