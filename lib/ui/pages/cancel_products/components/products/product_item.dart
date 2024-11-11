import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../../pages.dart';

class ProductItem extends StatelessWidget {
  final PrintedProductsViewModel product;
  final int index;
  final int productFlex;
  final int totalFlex;
  final int quantityFlex;
  final double deleteButtonSize;
  const ProductItem({
    required this.product,
    required this.index,
    required this.productFlex,
    required this.totalFlex,
    required this.quantityFlex,
    required this.deleteButtonSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index % 2 == 1
          ? Theme.of(context).primaryColorLight.withAlpha(30)
          : Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: productFlex,
            child: Text(
              product.Products.Name,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: quantityFlex,
            child: Text(
              product.Products.productQuantity.toString().toBrazilianNumber(0),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: totalFlex,
            child: Column(
              children: [
                Text(
                  product.TotalLiquid,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(
            width: deleteButtonSize,
            height: deleteButtonSize,
            child: IconButton(
              onPressed: () async {},
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
