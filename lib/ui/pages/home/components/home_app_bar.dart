import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

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
          child: Stack(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder()),
                onPressed: () {
                  homePresenter.goToPrintedProductsPage();
                },
                label: Center(
                  child: hasMinWidth(context)
                      ? const Text(
                          "SOLICITADOS",
                        )
                      : null,
                ),
                icon: const Icon(Icons.list),
              ),
              Positioned(
                top: 2,
                left: 5,
                child: InkWell(
                  onTap: () {
                    homePresenter.goToPrintedProductsPage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    maxRadius: 8,
                    minRadius: 8,
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          (printedProductsPresenter
                                      .printedProducts?.Products.length ??
                                  0)
                              .toString(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder()),
              onPressed: () {
                AnimatedAlertDialog.open(
                  context: context,
                  page: const CartPage(),
                );
              },
              label: Center(
                child: hasMinWidth(context)
                    ? const Text(
                        "CARRINHO",
                      )
                    : null,
              ),
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
            Positioned(
              top: 2,
              left: 5,
              child: InkWell(
                onTap: () {
                  AnimatedAlertDialog.open(
                    context: context,
                    page: const CartPage(),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  maxRadius: 8,
                  minRadius: 8,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        cartPresenter.cartProducts.length.toString(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
