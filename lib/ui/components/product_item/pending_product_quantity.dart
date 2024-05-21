import 'package:flutter/material.dart';

import '../../pages/pages.dart';

class PendingProductQuantity extends StatelessWidget {
  final SaleRequestTempPresenter saleRequestTempPresenter;
  final ProductsViewModel productsViewModel;
  const PendingProductQuantity({
    required this.saleRequestTempPresenter,
    required this.productsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_productQuantityInSaleRequestTemp(
            saleRequestTempPresenter: saleRequestTempPresenter,
            product: productsViewModel) >
        0) {
      return RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: _productQuantityInSaleRequestTemp(
                        saleRequestTempPresenter: saleRequestTempPresenter,
                        product: productsViewModel)
                    .toString(),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
            const TextSpan(
              text: ' pendente(s)',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}

int _productQuantityInSaleRequestTemp({
  required SaleRequestTempPresenter saleRequestTempPresenter,
  required ProductsViewModel product,
}) {
  return saleRequestTempPresenter.saleRequestTemp?.Products
          .where((element) =>
              element.Product.PriceLookupCode == product.PriceLookupCode)
          .length ??
      0;
}
