import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

PreferredSize homeAppBar({
  required HomePresenter homePresenter,
  required PrintedProductsPresenter printedProductsPresenter,
  required BuildContext context,
  required CartPresenter cartPresenter,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(40),
    child: AppBar(
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
      title: const TitleAppbar(),
      leading: const FittedBox(
        child: Row(
          children: [
            EnterpriseLogoImage(),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F8),
    ),
  );
}
