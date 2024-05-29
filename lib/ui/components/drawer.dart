import 'package:flutter/material.dart';

import '../pages/pages.dart';

Widget drawer({
  required BuildContext context,
  required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  required SaleRequestTempPresenter saleRequestTempPresenter,
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
            key: const Key("logout"),
            context: context,
            onTap: () async {
              homePresenter.goToSplashPage(
                printedProductsPresenter: printedProductsPresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
                expansibleGroupsPresenter: expansibleGroupsPresenter,
              );
              await homePresenter.clearEnterpriseData();
            },
            text: "Sair",
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
  required Key key,
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
