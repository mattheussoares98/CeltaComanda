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
    final presenter = Provider.of<ProductsPresenter>(context);
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
      child: GestureDetector(
        onTap: () {
          presenter.goToProductDetailsPage(product);
        },
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              children: [
                ImageWidget(product: product),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(5),
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
                        if (_productQuantityInSaleRequestTemp(
                                saleRequestTempPresenter:
                                    saleRequestTempPresenter,
                                product: product) >
                            0)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 4, 8, 0),
                            child: RichText(
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
                                    text: ' qtd no carrinho',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF57636C),
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 12, 4, 8),
                      child: Text(
                        'R\$${product.SaleRetailPraticed}',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
