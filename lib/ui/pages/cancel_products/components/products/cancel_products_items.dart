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
    CancelProductsPresenter cancelProductsPresenter =
        Provider.of(context, listen: false);

    return StreamBuilder<PrintedViewModel?>(
        stream: cancelProductsPresenter.printedProducts,
        builder: (context, snapshot) {
          if (snapshot.data == null || selectedCommandInDropDown == null) {
            return Center(
              child: Text(R.string.emptyTable),
            );
          }

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
                      itemCount: snapshot.data!.Products.length,
                      itemBuilder: (context, index) {
                        snapshot.data!.Products.sort(
                            (a, b) => a.Product.Name.compareTo(b.Product.Name));
                    
                        final product = snapshot.data!.Products[index];
                    
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
        });
  }
}
