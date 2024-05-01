import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';
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
    // GetxSaleRequestTempPresenter cartPresenter = Provider.of(context);
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
                    const Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 15,
                        end: 15,
                        top: 50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReturnIcon(),
                        ],
                      ),
                    ),
                  ],
                ),
                ProductName(name: product.Name),
                const ProductSubtitle(
                    title:
                        'Effortlessly flow from one space to the next in this sleeveless take on the classic trench coat. '),
                const ExpansibleOptions(),
              ],
            ),
          ),
        ),
        // AddProductInCart(
        //   onPressed: () async => await presenter.addProductInCart(
        //     product: product,
        //     saleRequestTempPresenter: cartPresenter,
        //   ),
        //   price: product.PackingAbbreviation,
        // ),
      ],
    );
  }
}
