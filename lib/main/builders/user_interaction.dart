import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main/builders/builders.dart';
import '../../ui/components/components.dart';
import '../../ui/pages/pages.dart';

class UserInteraction {
  UserInteraction._();

  static const timerShowMessageCartNotEmpty = Duration(seconds: 60);
  static const timerJumpToMenuPage = Duration(seconds: 120);

  static CartPresenter cartPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );

  static void handleUserInteraction([PageController? pageController]) {
    _timerToShowMessageCartNotEmpty.cancel();
    _timerToNavigateToMenuPage.cancel();

    _timerToShowMessageCartNotEmpty = Timer.periodic(
        timerShowMessageCartNotEmpty,
        (_) => _showCartNotEmptyMessage(pageController));

    _timerToNavigateToMenuPage = Timer.periodic(
        timerJumpToMenuPage, (_) => _jumpToMenuPage(pageController));
  }

  static void _jumpToMenuPage(PageController? pageController) {
    if (pageController != null) {
      pageController.jumpToPage(0);
      _timerToNavigateToMenuPage.cancel();
    }
  }

  static void _showCartNotEmptyMessage(PageController? pageController) {
    if (pageController != null) {
      pageController.jumpToPage(1);
    }

    if (cartPresenter.confirmedCombox.isNotEmpty ||
        cartPresenter.cartProducts.isNotEmpty) {
      showErrorMessage(
        NavigatorKey.navigatorKey.currentState!.context,
        "Há produtos no carrinho que não foram enviados ainda",
        duration: const Duration(seconds: 6),
      );
    }
    _timerToShowMessageCartNotEmpty.cancel();
  }

  static Timer _timerToShowMessageCartNotEmpty = Timer.periodic(
      timerShowMessageCartNotEmpty, (_) => _showCartNotEmptyMessage(null));

  static Timer _timerToNavigateToMenuPage =
      Timer.periodic(timerJumpToMenuPage, (_) => _jumpToMenuPage(null));
}
