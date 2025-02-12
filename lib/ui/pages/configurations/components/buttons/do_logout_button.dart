import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class DoLogoutButton extends StatelessWidget {
  const DoLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    EnterprisePresenter enterprisePresenter =
        Provider.of(context, listen: false);

    return DefaultButton(
        name: R.string.doLogout,
        function: () {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            notificationDialog(
                context: context,
                titleMessage: cartPresenter.cartProducts.isNotEmpty
                    ? R.string.clearCart
                    : R.string.doLogout,
                content: Text(
                  cartPresenter.cartProducts.isNotEmpty
                      ? R.string.msgClearCartOnLogout
                      : R.string.msgWantDoLogout,
                  textAlign: TextAlign.center,
                ),
                onPress: () async {
                  cartPresenter.clearCart();
                  await homePresenter.doLogout(
                    printedProductsPresenter: printedProductsPresenter,
                    cartPresenter: cartPresenter,
                    menuPresenter: menuPresenter,
                    enterprisePresenter: enterprisePresenter,
                  );
                });
          });
        });
  }
}
