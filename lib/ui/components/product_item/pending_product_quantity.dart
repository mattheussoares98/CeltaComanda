import 'package:flutter/material.dart';

import '../../pages/pages.dart';

class PendingProductQuantity extends StatelessWidget {
  final CartPresenter cartPresenter;
  final ProductsViewModel productsViewModel;
  const PendingProductQuantity({
    required this.cartPresenter,
    required this.productsViewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (_productQuantityInSaleRequestTemp(
            cartPresenter: cartPresenter,
            product: productsViewModel) >
        0) {
      return RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: _productQuantityInSaleRequestTemp(
                        cartPresenter: cartPresenter,
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
  required CartPresenter cartPresenter,
  required ProductsViewModel product,
}) {
  return cartPresenter.saleRequestTemp?.Products
          .where((element) =>
              element.Product.PriceLookupCode == product.PriceLookupCode)
          .length ??
      0;
}
