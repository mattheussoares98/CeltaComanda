import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

class PriceAndUpdateProductQuantity extends StatelessWidget {
  final void Function()? onPressedReduceQuantity;
  final void Function()? onPressedAddQuantity;
  final String productQuantity;
  final String price;
  final String totalLiquid;
  const PriceAndUpdateProductQuantity({
    required this.onPressedReduceQuantity,
    required this.onPressedAddQuantity,
    required this.productQuantity,
    required this.price,
    required this.totalLiquid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Preço $price R\$"),
        Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              IconButton(
                key: const Key("IconButtonSubtractQuantity"),
                icon: Icon(
                  productQuantity.toDouble() <= 1 ? Icons.delete : Icons.remove,
                ),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                onPressed: onPressedReduceQuantity,
                color: const Color(0xFFFF5963),
              ),
              Text(productQuantity),
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
        Text("Total $totalLiquid R\$"),
      ],
    );
  }
}
