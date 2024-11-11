import 'package:flutter/material.dart';

import '../../../pages.dart';

class CancelProductsItems extends StatelessWidget {
  final int? selectedCommandInDropDown;
  final PrintedViewModel printed;
  const CancelProductsItems({
    required this.selectedCommandInDropDown,
    required this.printed,
    super.key,
  });

  final int productFlex = 6;
  final int quantityFlex = 2;
  final int totalFlex = 3;
  final double deleteButtonSize = 43;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ProductsHeader(
            productFlex: productFlex,
            quantityFlex: quantityFlex,
            totalFlex: totalFlex,
            deleteButtonSize: deleteButtonSize,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                itemCount: printed.Products.length,
                itemBuilder: (context, index) {
                  printed.Products.sort(
                      (a, b) => a.Product.Name.compareTo(b.Product.Name));

                  final product = printed.Products[index];

                  return ProductItem(
                    product: product,
                    index: index,
                    productFlex: productFlex,
                    totalFlex: totalFlex,
                    quantityFlex: quantityFlex,
                    deleteButtonSize: deleteButtonSize,
                    commandNumber: selectedCommandInDropDown,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
