import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class CancelProductsItems extends StatelessWidget {
  final int? selectedCommandInDropDown;
  const CancelProductsItems({
    required this.selectedCommandInDropDown,
    super.key,
  });

  final int productFlex = 6;
  final int quantityFlex = 2;
  final int totalFlex = 3;
  final double deleteButtonSize = 43;

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);

    if (printedProductsPresenter.printedProducts == null ||
        selectedCommandInDropDown == null) {
      return Center(
        child: Text(R.string.emptyTable),
      );
    }

    return Expanded(
      child: Column(
        children: [
          if (printedProductsPresenter.printedProducts != null)
            ProductsHeader(
              productFlex: productFlex,
              quantityFlex: quantityFlex,
              totalFlex: totalFlex,
              deleteButtonSize: deleteButtonSize,
            ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  printedProductsPresenter.printedProducts!.Products.length,
              itemBuilder: (context, index) {
                printedProductsPresenter.printedProducts!.Products
                    .sort((a, b) => a.Products.Name.compareTo(b.Products.Name));

                if (printedProductsPresenter.printedProducts == null) {
                  return SizedBox();
                }

                final product =
                    printedProductsPresenter.printedProducts!.Products[index];

                return ProductItem(
                  product: product,
                  index: index,
                  productFlex: productFlex,
                  totalFlex: totalFlex,
                  quantityFlex: quantityFlex,
                  deleteButtonSize: deleteButtonSize,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
