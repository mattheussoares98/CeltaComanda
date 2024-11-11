import 'package:flutter/material.dart';

import '../../../../../main/builders/builders.dart';
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
      backgroundColor: const Color(0xFFF1F5F8),
      actions: [
        if (homePresenter.isGeneratingVersionToRede ||
            EnterpriseDataBuilder.enterpriseDataEntity?.useCovenant == true)
          SizedBox(
            width: MediaQuery.of(context).size.width *
                (hasMinWidth(context) ? 0.2 : 0.16),
            child: Padding(
              padding: const EdgeInsets.only(right: 1),
              child: AppBarButton(
                onPress: homePresenter.goToPaymentPage,
                icon: Icons.monetization_on,
                isPrice: true,
                buttonName: R.string.pay,
                quantityString:
                    printedProductsPresenter.totalLiquid.toDouble().toString(),
              ),
            ),
          ),
        SizedBox(
          width: MediaQuery.of(context).size.width *
              (hasMinWidth(context) ? 0.2 : 0.16),
          child: Padding(
            padding: const EdgeInsets.only(right: 1),
            child: AppBarButton(
              onPress: homePresenter.goToPrintedProductsPage,
              buttonName: R.string.requested,
              icon: Icons.list,
              quantityString:
                  (printedProductsPresenter.printed?.Products.length ?? 0)
                      .toString(),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width *
              (hasMinWidth(context) ? 0.2 : 0.16),
          child: AppBarButton(
            onPress: () {
              PersonalizedDialogPage.open(
                context: context,
                page: const CartPage(),
              );
            },
            icon: Icons.shopping_cart_outlined,
            buttonName: R.string.cart,
            quantityString: cartPresenter.cartProducts.length.toString(),
          ),
        ),
      ],
    ),
  );
}
