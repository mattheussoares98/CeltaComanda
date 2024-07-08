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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.Name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: hasMinWidth(context) ? 30 : 18,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showLargeImage(
                    context: context,
                    ean: product.EanCode,
                    productComplement: product.ProductComplement,
                    plu: product.PriceLookupCode,
                    menuPresenter: menuPresenter,
                    productName: product.Name,
                    selectedProduct: product,
                  );
                },
                child: ImageWidget(
                  ean: product.EanCode,
                  plu: product.PriceLookupCode,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: printedProductsPresenter.canCancelProducts
                      ? onPressedRemoveProduct
                      : validateUserAndCancelProducts,
                  icon: Icon(
                    Icons.delete,
                    color: printedProductsPresenter.canCancelProducts
                        ? Colors.red
                        : Colors.grey,
                    size: hasMinWidth(context) ? 30 : 25,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                // Text(
                //   value.addBrazilianCoin(),
                //   style: TextStyle(
                //     fontSize: hasMinWidth(context) ? 23 : 15,
                //     fontWeight: FontWeight.w300,
                //   ),
                // ),
                Text(
                  "$quantity qtd",
                  style: TextStyle(
                    fontSize: hasMinWidth(context) ? 23 : 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  totalLiquid.addBrazilianCoin(),
                  style: TextStyle(
                    fontSize: hasMinWidth(context) ? 23 : 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (comments != null) CommentRichText(comment: comments!),
      ],
    );
  }
}
