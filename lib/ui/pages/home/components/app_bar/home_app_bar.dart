import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

PreferredSize homeAppBar({
  required HomePresenter homePresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required BuildContext context,
  required CartPresenter cartPresenter,
  required MenuPresenter menuPresenter,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(hasMinWidth(context) ? 60 : 40),
    child: AppBar(
      title: const TitleAppbar(),
      leading: FittedBox(
        child: Row(
          children: [
            if (!homePresenter.isFixedCommandNumber)
              IconButton(
                onPressed: () {
                  notificationDialog(
                      context: context,
                      titleMessage: R.string.doLogout,
                      content: Text(R.string.msgWantDoLogout),
                      onPress: () async {
                        await homePresenter.goToSplashPage(
                          printedProductsPresenter: printedProductsPresenter,
                          cartPresenter: cartPresenter,
                          menuPresenter: menuPresenter,
                        );
                        await cartPresenter.clearCart();
                      });
                },
                icon: const Icon(Icons.logout),
              ),
            const EnterpriseLogoImage(),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F8),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 1),
          child: AppBarButton(
            onPress: homePresenter.goToPrintedProductsPage,
            buttonName: R.string.requested,
            icon: Icons.list,
            quantity:
                (printedProductsPresenter.printedProducts?.Products.length ??
                    0),
          ),
        ),
        AppBarButton(
          onPress: () {
            AnimatedAlertDialog.open(
              context: context,
              page: const CartPage(),
            );
          },
          icon: Icons.shopping_cart_outlined,
          buttonName: R.string.cart,
          quantity: cartPresenter.cartProducts.length,
        ),
      ],
    ),
  );
}
