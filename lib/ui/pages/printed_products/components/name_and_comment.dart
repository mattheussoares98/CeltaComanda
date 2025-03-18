import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class NameAndComment extends StatelessWidget {
  final PrintedProductsViewModel product;
  final String? comments;
  const NameAndComment({
    required this.product,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${product.Product?.Name}${product.Product?.Name}${product.IsCancelled == "true" ? " (cancelado)" : ""}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: StringSize.size,
          ),
        ),
        if (comments != null) Comment(comment: "($comments)"),
      ],
    );
  }
}
