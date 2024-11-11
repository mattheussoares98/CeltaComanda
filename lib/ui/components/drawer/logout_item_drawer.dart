import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../pages/pages.dart';
import '../components.dart';

class LogoutItemDrawer extends StatelessWidget {
  const LogoutItemDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    EnterprisePresenter enterprisePresenter =
        Provider.of(context, listen: false);

    return DrawerItem(
      onTap: () async {
        if (cartPresenter.cartProducts.isNotEmpty) {
          notificationDialog(
              context: context,
              titleMessage: R.string.doLogout,
              content: Text(R.string.msgIfLogoutClearCart),
              onPress: () async {
                await _logout(
                  homePresenter: homePresenter,
                  printedProductsPresenter: printedProductsPresenter,
                  cartPresenter: cartPresenter,
                  menuPresenter: menuPresenter,
                  enterprisePresenter: enterprisePresenter,
                );
              });
        } else {
          notificationDialog(
              context: context,
              titleMessage: R.string.doLogout,
              content: null,
              onPress: () async {
                await _logout(
                  homePresenter: homePresenter,
                  printedProductsPresenter: printedProductsPresenter,
                  cartPresenter: cartPresenter,
                  menuPresenter: menuPresenter,
                  enterprisePresenter: enterprisePresenter,
                );
              });
        }
      },
      leading: Icon(
        Icons.logout,
        color: Theme.of(context).colorScheme.primary,
      ),
      name: R.string.exit,
    );
  }
}

Future<void> _logout({
  required HomePresenter homePresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required CartPresenter cartPresenter,
  required MenuPresenter menuPresenter,
  required EnterprisePresenter enterprisePresenter,
}) async {
  await cartPresenter.clearCart();
  await homePresenter.doLogout(
    printedProductsPresenter: printedProductsPresenter,
    cartPresenter: cartPresenter,
    menuPresenter: menuPresenter,
    enterprisePresenter: enterprisePresenter,
  );
}
