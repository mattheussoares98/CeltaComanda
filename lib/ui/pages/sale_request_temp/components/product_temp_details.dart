// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../pages.dart';

class ProductTempDetails extends StatelessWidget {
  final ProductsViewModel Product;
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final void Function()? onPressedRemoveProduct;
  final String quantity;
  final String value;
  final String totalLiquid;
  final String? comments;

  const ProductTempDetails({
    required this.Product,
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.onPressedRemoveProduct,
    required this.quantity,
    required this.value,
    required this.totalLiquid,
    this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
            _UpdateQuantity(
              onPressedReduceQuantity: onPressedReduceQuantity,
              quantity: quantity,
              onPressedAddQuantity: onPressedAddQuantity,
              price: value,
              totalLiquid: totalLiquid,
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

class _UpdateQuantity extends StatelessWidget {
  const _UpdateQuantity({
    required this.onPressedReduceQuantity,
    required this.quantity,
    required this.onPressedAddQuantity,
    required this.price,
    required this.totalLiquid,
  });

  final void Function()? onPressedReduceQuantity;
  final String quantity;
  final void Function()? onPressedAddQuantity;
  final String price;
  final String totalLiquid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  double.parse(quantity.replaceAll(RegExp(r','), '.')) <= 1
                      ? Icons.delete
                      : Icons.remove,
                ),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                onPressed: onPressedReduceQuantity,
                color: const Color(0xFFFF5963),
              ),
              Text(quantity),
              IconButton(
                icon: const Icon(
                  Icons.add,
                ),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                onPressed: onPressedAddQuantity,
                color: const Color(0xFFFF5963),
              ),
            ],
          ),
        ),
        Text("Preço $price R\$"),
        Text("Total $totalLiquid R\$"),
      ],
    );
  }
}
