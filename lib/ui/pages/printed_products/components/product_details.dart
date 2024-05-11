// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../presentation/presenters/presenters.dart';
import '../../pages.dart';

class ProductDetails extends StatelessWidget {
  final ProductsViewModel Product;
  final void Function()? onPressedRemoveProduct;
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
    this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (Product.EanCode != null)
                        Text(
                          "EAN: ${Product.EanCode!}",
                        ),
                      Text(
                        "PLU: ${Product.PriceLookupCode}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Preço $value R\$"),
                Row(
                  children: [
                    Text("Qtd: $quantity"),
                    StreamBuilder<bool>(
                        stream:
                            printedProductsPresenter.canCancelProductsStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return SizedBox(
                              height: 35,
                              width: 35,
                              child: FittedBox(
                                child: IconButton(
                                  onPressed: onPressedRemoveProduct,
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
                  ],
                ),
                Text("Total $totalLiquid R\$"),
              ],
            ),
          ],
        ),
        if (comments != null) Text("Comentário: $comments"),
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }
}
