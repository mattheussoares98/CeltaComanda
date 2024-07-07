import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class ProductDetails extends StatelessWidget {
  final ProductsViewModel product;
  final void Function()? onPressedRemoveProduct;
  final void Function()? validateUserAndCancelProducts;
  final String quantity;
  final String value;
  final String totalLiquid;
  final String? comments;

  const ProductDetails({
    required this.product,
    required this.onPressedRemoveProduct,
    required this.quantity,
    required this.value,
    required this.totalLiquid,
    required this.validateUserAndCancelProducts,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageWidget(
              ean: product.EanCode,
              plu: product.PriceLookupCode,
              height: 150,
              width: 150,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                product.Name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: hasMinWidth(context) ? 30 : 18,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value.addBrazilianCoin()),
                Row(
                  children: [
                    Text("Qtd $quantity"),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: FittedBox(
                        child: IconButton(
                          onPressed: printedProductsPresenter.canCancelProducts
                              ? onPressedRemoveProduct
                              : validateUserAndCancelProducts,
                          icon: Icon(
                            Icons.delete,
                            color: printedProductsPresenter.canCancelProducts
                                ? Colors.red
                                : Colors.grey,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(totalLiquid.addBrazilianCoin()),
              ],
            ),
          ],
        ),
        if (comments != null) CommentRichText(comment: comments!),
      ],
    );
  }
}
