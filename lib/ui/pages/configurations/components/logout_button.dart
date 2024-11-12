import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    EnterprisePresenter enterprisePresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      child: Padding(
        padding: EdgeInsets.all(hasMinWidth(context) ? 8.0 : 0),
        child: FittedBox(
          child: Text(
            R.string.doLogout,
            style: TextStyle(
              fontSize: getStringSize(context),
            ),
          ),
        ),
      ),
      onPressed: () async {
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
      },
    );
  }
}
