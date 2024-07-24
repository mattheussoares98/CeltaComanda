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

  static const _duration = Duration(seconds: 150);
  static Timer _timer =
      Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());

  static void restartTime() {
    if (!_dialogIsOpen) {
      _timer.cancel();
      _timer = Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());
    }
  }

  static bool _dialogIsOpen = false;
  static void _showCartNotEmptyMessage() async {
    _timer.cancel();

    _dialogIsOpen = true;

    await notificationDialog(
      context: NavigatorKey.navigatorKey.currentState!.context,
      canPop: false,
      titleMessage: "",
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
            "Há produtos no carrinho que não foram enviados. Pode ser que você tenha esquecido de enviar"),
      ),
      onPress: () async {
        await openCartPageDialog(NavigatorKey.navigatorKey.currentState!.context);
        _dialogIsOpen = false;
      },
      cancelMessage: null,
      confirmMessage: "ABRIR CARRINHO",
    );
  }
}
