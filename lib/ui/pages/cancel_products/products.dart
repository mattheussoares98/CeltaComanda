import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(
      context,
      listen: false,
    );

    return ListView.builder(
      shrinkWrap: true,
      itemCount: printedProductsPresenter.printedProducts?.Products.length,
      itemBuilder: (context, printedIndex) {
        if (printedProductsPresenter.printedProducts == null) {
          return SizedBox();
        }
        final product =
            printedProductsPresenter.printedProducts!.Products[printedIndex];

        return Row(
          children: [
            Expanded(child: Text(product.Products.Name)),
            Expanded(
              child: Text(
                product.Products.productQuantity.toString(),
              ),
            ),
            Expanded(child: Text(product.TotalLiquid)),
            IconButton(
              onPressed: () async {},
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
