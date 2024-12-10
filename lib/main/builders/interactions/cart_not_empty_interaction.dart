import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../../ui/helpers/helpers.dart';
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
    _alertMessageIsOpen = false;
    if (!PersonalizedDialogPage.isOpen && _alertMessageIsOpen == false) {
      _timer.cancel();
      _timer = Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());
    }
  }

  static bool _alertMessageIsOpen = false;

  static Future<void> _showCartNotEmptyMessage() async {
    if (PersonalizedDialogPage.isOpen ||
        _alertMessageIsOpen ||
        cartPresenter.cartProducts.isEmpty) {
      return;
    }
    _alertMessageIsOpen = true;
    _timer.cancel();

    Navigator.of(NavigatorKey.navigatorKey.currentState!.context).popUntil(
      (route) => route.isFirst,
    );

    await PersonalizedDialogPage.open(
      context: NavigatorKey.navigatorKey.currentState!.context,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(NavigatorKey.navigatorKey.currentState!.context)
                    .pop();
                await PersonalizedDialogPage.open(
                    context: NavigatorKey.navigatorKey.currentState!.context,
                    page: const CartPage());
                restartTime();
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "VISUALIZAR CARRINHO",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
      page: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Seu pedido está pendente!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(
                  NavigatorKey.navigatorKey.currentState!.context,
                ).primaryColorDark,
                fontSize: getStringSize(
                  NavigatorKey.navigatorKey.currentState!.context,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Há produtos no carrinho que não foram enviados. Pode ser que você tenha esquecido de enviar",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(
                  NavigatorKey.navigatorKey.currentState!.context,
                ).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
    restartTime();
  }
}
