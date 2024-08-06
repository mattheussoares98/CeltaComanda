import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LogoutButton extends StatelessWidget {
  final bool isValidUserAndPassword;
  final Function() changeIsUpdatingCommandNumber;
  const LogoutButton({
    required this.isValidUserAndPassword,
    required this.changeIsUpdatingCommandNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return TextButton(
      child: FittedBox(
        child: Text(
          "Fazer logout",
          style: TextStyle(
            fontSize: getStringSize(context),
          ),
        ),
      ),
      onPressed: () async {
        changeIsUpdatingCommandNumber();
        if (isValidUserAndPassword) {
          if (cartPresenter.cartProducts.isNotEmpty) {
            notificationDialog(
                context: context,
                titleMessage: "Limpar carrinho",
                content:
                    const Text("Ao fazer o logout, o carrinho será limpo!"),
                onPress: () async {
                  if (isValidUserAndPassword) {
                    cartPresenter.clearCart();
                    await homePresenter.goToSplashPage(
                      printedProductsPresenter: printedProductsPresenter,
                      cartPresenter: cartPresenter,
                      menuPresenter: menuPresenter,
                    );
                  }
                });
          } else {
            await homePresenter.goToSplashPage(
              printedProductsPresenter: printedProductsPresenter,
              cartPresenter: cartPresenter,
              menuPresenter: menuPresenter,
            );
          }
        }
      },
    );
  }
}
