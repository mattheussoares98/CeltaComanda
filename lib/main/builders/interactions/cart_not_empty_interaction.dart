import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import '../builders.dart';

class CartNotEmptyInteraction {
  static CartPresenter cartPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );

  static const _duration = Duration(seconds: 60);
  static Timer _timer =
      Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());

  static PageController? pageControllerOfMenuPage;

  static void restartTime(PageController? pageController) {
    if (pageController != null) {
      pageControllerOfMenuPage = pageController;
    }

    _timer.cancel();
    _timer = Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());
  }

  static void _showCartNotEmptyMessage() {
    _timer.cancel();

    Navigator.of(NavigatorKey.navigatorKey.currentState!.context)
        .popUntil((route) => route.isFirst);

    if (pageControllerOfMenuPage != null) {
      pageControllerOfMenuPage!.jumpToPage(1);
    }

    if (cartPresenter.confirmedCombox.isNotEmpty ||
        cartPresenter.cartProducts.isNotEmpty) {
      showErrorMessage(
        NavigatorKey.navigatorKey.currentState!.context,
        "Há produtos no carrinho que não foram enviados ainda. Pode ser que você tenha esquecido de enviar",
        duration: const Duration(seconds: 6),
      );
    }
  }
}
