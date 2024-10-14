import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../pages/pages.dart';
import '../components.dart';

class LogoutItemDrawer extends StatelessWidget {
  const LogoutItemDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePresenter homePresenter = Provider.of(context, listen: false);
    final PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    final CartPresenter cartPresenter = Provider.of(context, listen: false);
    final MenuPresenter menuPresenter = Provider.of(context, listen: false);

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
                );
              });
        } else {
          await _logout(
            homePresenter: homePresenter,
            printedProductsPresenter: printedProductsPresenter,
            cartPresenter: cartPresenter,
            menuPresenter: menuPresenter,
          );
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
}) async {
  homePresenter.goToSplashPage(
    printedProductsPresenter: printedProductsPresenter,
    cartPresenter: cartPresenter,
    menuPresenter: menuPresenter,
  );
  await homePresenter.clearEnterpriseData();
  await cartPresenter.clearCart();
}
