import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';

class ProductsItems extends StatelessWidget {
  final List<ProductsViewModel> products;
  const ProductsItems({
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    ProductsPresenter productsPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final productViewModel = products[index];

          return ProductItem(
            goToComboxPage: () {
              productsPresenter.goToComboxPage(
                int.parse(
                  productViewModel.InternalCodeOfProductOnERP!,
                ),
              );
            },
            product: productViewModel,
            updateProductQuantity: () async {
              await productsPresenter.updateSaleRequest(
                productsViewModel: productViewModel,
                homePresenter: homePresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
              );
            },
          );
        },
      ),
    );
  }
}
