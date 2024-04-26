import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String? nameComplete;
  final String name;
  final String? eanCode;
  final String plu;

  const ProductDetails({
    required this.nameComplete,
    required this.name,
    required this.eanCode,
    required this.plu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              nameComplete != null ? nameComplete! : name,
            ),
          ),
          if (eanCode != null)
            Text(
              "EAN: ${eanCode!}",
            ),
          Text(
            "PLU: $plu",
          ),
        ],
      ),
    );
  }
}
