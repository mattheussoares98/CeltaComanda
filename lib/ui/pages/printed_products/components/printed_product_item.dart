import 'package:flutter/material.dart';

import '../../pages.dart';

class PrintedProductItem extends StatelessWidget {
  final PrintedProductViewModel product;
  final String quantity;
  const PrintedProductItem({
    required this.product,
    required this.quantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ImageWidget(product: product),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  product.NameComplete != null
                      ? product.NameComplete!
                      : product.Name,
                ),
              ),
              if (product.EanCode != null)
                Text(
                  "EAN: ${product.EanCode!}",
                ),
              Text(
                "PLU: ${product.PriceLookupCode}",
              ),
            ],
          ),
        ),
        FittedBox(
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  color: const Color(0xFFFF5963),
                ),
                Text(quantity),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                  ),
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  color: const Color(0xFFFF5963),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
