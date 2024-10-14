import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../pages/pages.dart';

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

Widget drawer({
  required BuildContext context,
  required MenuPresenter menuPresenter,
  required CartPresenter cartPresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required HomePresenter homePresenter,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.7,
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              "lib/ui/assets/images/logoCeltaTransparente.png",
              fit: BoxFit.cover,
            ),
          ),
          _drawerItem(
            context: context,
            onTap: () async {
              Navigator.of(context).pop();
            },
            text: R.string.support,
            leading: Icon(
              Icons.phone,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          _drawerItem(
            context: context,
            onTap: () async {
              Navigator.of(context).pop();
              PersonalizedDialogPage.open(
                context: context,
                page: const TableConfigurationsPage(),
              );
            },
            text: R.string.configurations,
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          _drawerItem(
            key: const Key("logout"),
            context: context,
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
            text: R.string.exit,
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _drawerItem({
  required BuildContext context,
  required Function()? onTap,
  required String text,
  required Widget leading,
  Key? key,
}) {
  return GestureDetector(
    key: key,
    onTap: onTap,
    child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          )),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: leading,
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    ),
  );
}
