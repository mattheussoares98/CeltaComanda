import 'package:flutter/material.dart';

class ProductNameEanPluAndAddComment extends StatelessWidget {
  final String? nameComplete;
  final String name;
  final String? eanCode;
  final String priceLookupCode;
  final String? comments;
  final void Function()? onTapCommentIcon;
  const ProductNameEanPluAndAddComment({
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
            children: [
              if (eanCode != null)
                Text(
                  "EAN: ${eanCode!}",
                ),
              Text(
                "PLU: $priceLookupCode",
              ),
            ],
          ),
          if (comments == null)
            GestureDetector(
              onTap: onTapCommentIcon,
              child: Icon(
                color: Theme.of(context).colorScheme.primary,
                Icons.add_comment,
                size: 25,
              ),
            ),
        ],
      ),
    );
  }
}
