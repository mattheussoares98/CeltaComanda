// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/convert/convert.dart';
import '../../pages.dart';

class ProductDetails extends StatelessWidget {
  final ProductsViewModel Product;
  final void Function()? onPressedRemoveProduct;
  final void Function()? validateUserAndCancelProducts;
  final String quantity;
  final String value;
  final String totalLiquid;
  final String? comments;

  const ProductDetails({
    required this.Product,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(
              ean: Product.EanCode,
              plu: Product.PriceLookupCode,
              showLargeImageInShowDialog: true,
              beginAnimation: 1,
              endAnimation: 0.7,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Product.NameComplete != null
                        ? Product.NameComplete!
                        : Product.Name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // Text(
                  //   Product.PriceLookupCode,
                  // ),
                  // if (Product.EanCode != null)
                  //   Text(
                  //     Product.EanCode!,
                  //   ),
                ],
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
