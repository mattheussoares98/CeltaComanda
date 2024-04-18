import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
import '../../products/components/components.dart';

class ProductDetailItem extends StatelessWidget {
  final ProductsViewModel product;
  final ProductDetailsPresenter presenter;
  const ProductDetailItem({
    required this.product,
    required this.presenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    ImageWidget(
                      product: product,
                      height: 250,
                      width: double.infinity,
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const ReturnIcon(),
                          ProductDetailsCartIcon(
                            goToCartPage: presenter.goToCartPage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ProductName(name: product.name),
                const ProductSubtitle(
                    title:
                        'Effortlessly flow from one space to the next in this sleeveless take on the classic trench coat. '),
                const ExpansibleOptions(),
              ],
            ),
          ),
        ),
        AddProductInCart(
          // onPressed: () => presenter.addProductInCart(product),
          onPressed: null,
          price: product.price,
        ),
      ],
    );
  }
}
