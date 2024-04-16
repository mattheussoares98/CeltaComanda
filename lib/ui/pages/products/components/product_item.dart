import 'package:clean_celta_mobile/ui/pages/products/components/image_widget.dart';
import 'package:clean_celta_mobile/ui/pages/products/products.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductsViewModel product;
  const ProductItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<ProductsPresenter>(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
      child: GestureDetector(
        onTap: () {
          presenter.updateSelectedProduct(product);
          presenter.goToProductDetailsPage();
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
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ImageWidget(product: product),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 4, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                          child: Text(
                            'Subtítulo',
                            textAlign: TextAlign.start,
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
                        'R\$${product.price}',
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
