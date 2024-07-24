import 'dart:async';

import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../ui/pages/pages.dart';
import '../builders.dart';

class CartNotEmptyInteraction {
  static CartPresenter cartPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );

  static const _duration = Duration(seconds: 3);
  static Timer _timer =
      Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());

  static void restartTime() {
    if (!CartPageDialog.isOpen && !_alertMessageIsOpen) {
      _timer.cancel();
      _timer = Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());
    }
  }

  static bool _alertMessageIsOpen = false;

  static void _showCartNotEmptyMessage() async {
    if (CartPageDialog.isOpen || _alertMessageIsOpen) {
      return;
    }
    _alertMessageIsOpen = true;
    _timer.cancel();

    Navigator.of(NavigatorKey.navigatorKey.currentState!.context).popUntil(
      (route) => route.isFirst,
    );
    await showDialog(
        context: NavigatorKey.navigatorKey.currentState!.context,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2,
                vertical: MediaQuery.of(context).size.height * 0.2,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
              actionsAlignment: MainAxisAlignment.center,
              title: const Icon(Icons.info, size: 50),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Seu pedido está pendente!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: getStringSize(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Há produtos no carrinho que não foram enviados. Pode ser que você tenha esquecido de enviar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await CartPageDialog.open(
                        NavigatorKey.navigatorKey.currentState!.context);
                    _alertMessageIsOpen = false;
                    restartTime();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "VISUALIZAR CARRINHO",
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
