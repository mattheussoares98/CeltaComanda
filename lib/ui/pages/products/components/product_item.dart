import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';

int _productQuantityInSaleRequestTemp({
  required SaleRequestTempPresenter saleRequestTempPresenter,
  required ProductsViewModel product,
}) {
  return saleRequestTempPresenter.saleRequestTemp!.Products
      .where((element) =>
          element.Product.PriceLookupCode == product.PriceLookupCode)
      .length;
}

class ProductItem extends StatelessWidget {
  final ProductsViewModel product;
  const ProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
      child: GestureDetector(
        onTap: () {
          // presenter.goToProductDetailsPage(product);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x411D2429),
                offset: Offset(
                  0.0,
                  1,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // ImageWidget(product: product),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.Name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      product.PriceLookupCode,
                    ),
                    if (product.EanCode != null)
                      Text(
                        product.EanCode!,
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'R\$${product.SaleRetailPraticed}',
                    textAlign: TextAlign.end,
                  ),
                  if (_productQuantityInSaleRequestTemp(
                          saleRequestTempPresenter: saleRequestTempPresenter,
                          product: product) >
                      0)
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: _productQuantityInSaleRequestTemp(
                                      saleRequestTempPresenter:
                                          saleRequestTempPresenter,
                                      product: product)
                                  .toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                          const TextSpan(
                            text: ' no carrinho',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF57636C),
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
