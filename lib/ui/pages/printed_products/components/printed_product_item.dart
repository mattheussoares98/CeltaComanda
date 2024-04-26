import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class PrintedProductItem extends StatelessWidget {
  final ProductsViewModel product;
  final String quantity;
  final String totalLiquid;
  final String? comments;
  const PrintedProductItem({
    required this.product,
    required this.quantity,
    required this.totalLiquid,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter =
        Provider.of<PrintedProductsPresenter>(context, listen: false);
    return Row(
      children: [
        // ImageWidget(product: product),
        ProductDetails(
          nameComplete: product.NameComplete,
          name: product.Name,
          eanCode: product.EanCode,
          plu: product.PriceLookupCode,
          comments: comments,
          saleRetailPraticed: product.SaleRetailPraticed,
          totalLiquid: totalLiquid,
          quantity: quantity,
          onPressedAddQuantity: null,
          onPressedReduceQuantity: null,
          isPrintedProducts: true,
          onPressedRemoveProduct: () async => await presenter.removeProduct(),
        ),
      ],
    );
  }
}
