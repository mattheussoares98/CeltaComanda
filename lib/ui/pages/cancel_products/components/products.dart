import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Products extends StatelessWidget {
  final int? selectedCommandInDropDown;
  const Products({
    required this.selectedCommandInDropDown,
    super.key,
  });

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
      child: ListView.builder(
        itemCount:
            printedProductsPresenter.printedProducts!.Products.length + 1,
        itemBuilder: (context, index) {
          printedProductsPresenter.printedProducts!.Products
              .sort((a, b) => a.Products.Name.compareTo(b.Products.Name));

          if (printedProductsPresenter.printedProducts == null) {
            return SizedBox();
          }

          PrintedProductsViewModel? product;
          if (index != 0) {
            product =
                printedProductsPresenter.printedProducts!.Products[index - 1];
          }

          return Column(
            children: [
              Container(
                color: index % 2 == 1
                    ? Theme.of(context).primaryColorLight.withAlpha(30)
                    : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            if (index == 0) Text(R.string.products),
                            if (product != null) Text(product.Products.Name),
                          ],
                        )),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          if (index == 0) Text(R.string.quantityAbbreviated),
                          if (product != null)
                            Text(
                              product.Products.productQuantity
                                  .toString()
                                  .toBrazilianNumber(0),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          if (index == 0)
                            Text(R.string.total.addBrazilianCoin()),
                          if (product != null) Text(product.TotalLiquid),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: index == 0 ? null : () async {},
                      icon: Icon(
                        Icons.delete,
                        color: index == 0 ? Colors.transparent : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
