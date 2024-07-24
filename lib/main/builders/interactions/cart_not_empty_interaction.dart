import 'dart:async';

import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import '../builders.dart';

class CartNotEmptyInteraction {
  static CartPresenter cartPresenter = Provider.of(
    NavigatorKey.navigatorKey.currentState!.context,
    listen: false,
  );

  static const _duration = Duration(seconds: 10);
  static Timer _timer =
      Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());

  static void restartTime() {
    _timer.cancel();
    _timer = Timer.periodic(_duration, (_) => _showCartNotEmptyMessage());
  }

  static void _showCartNotEmptyMessage() {
    _timer.cancel();

    notificationDialog(
      context: NavigatorKey.navigatorKey.currentState!.context,
      titleMessage: "",
      content: const OpenCartPage(),
      onPress: () async {},
    );

    showErrorMessage(
      NavigatorKey.navigatorKey.currentState!.context,
      "Há produtos no carrinho que não foram enviados ainda. Pode ser que você tenha esquecido de enviar",
      duration: const Duration(seconds: 6),
    );
  }
}
