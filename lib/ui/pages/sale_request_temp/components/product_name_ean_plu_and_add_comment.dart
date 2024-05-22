import 'package:flutter/material.dart';

class ProductNamePluAndEan extends StatelessWidget {
  final String? nameComplete;
  final String name;
  final String? eanCode;
  final String priceLookupCode;
  final String? comments;
  final void Function()? onTapCommentIcon;
  const ProductNamePluAndEan({
    required this.nameComplete,
    required this.name,
    required this.eanCode,
    required this.priceLookupCode,
    required this.comments,
    required this.onTapCommentIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nameComplete != null ? nameComplete! : name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(priceLookupCode),
              if (eanCode?.isNotEmpty == true) Text(eanCode!),
            ],
          ),
        ],
      ),
    );
  }
}
