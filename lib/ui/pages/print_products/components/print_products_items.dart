import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class PrintProductsItems extends StatelessWidget {
  const PrintProductsItems({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: printedProductsPresenter.printed!.Products.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            children: [
              // Expanded(child: Text(R.string.time, style: textStyle(context))),
              Expanded(
                flex: 3,
                child: Text(R.string.products, style: textStyle(context)),
              ),
              Expanded(
                  child: Text(R.string.quantityAbbreviated,
                      style: textStyle(context))),
              Expanded(
                child: Text(
                  R.string.total.addBrazilianCoin(),
                  style: textStyle(context),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          );
        }
        final product = printedProductsPresenter.printed!.Products[index - 1];

        return Row(
          children: [
            // Expanded(child: RequestedAt(printedProduct: product)),
            Expanded(
              flex: 3,
              child: Text(product.Product!.Name, style: textStyle(context)),
            ),
            Expanded(child: Text(product.Quantity!, style: textStyle(context))),
            Expanded(
                child: Text(
              product.TotalLiquid!,
              style: textStyle(context),
              textAlign: TextAlign.end,
            )),
          ],
        );
      },
    );
  }
}
