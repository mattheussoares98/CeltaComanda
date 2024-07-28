import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class TotalPriceCombox extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final int totalProductsQuantity;
  final double totalLiquid;

  const TotalPriceCombox({
    required this.selectedProduct,
    required this.totalProductsQuantity,
    required this.totalLiquid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);

    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Total",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              (insertProductsPresenter.totalProductsQuantity * totalLiquid)
                  .toString()
                  .toBrazilianNumber()
                  .addBrazilianCoin(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: getStringSize(context) * 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
