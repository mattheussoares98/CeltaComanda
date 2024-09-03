import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';

class ProductDetails extends StatelessWidget {
  final ProductsViewModel product;
  final PrintedViewModel printed;
  final String quantity;
  final String value;
  final String totalLiquid;
  final String? comments;

  const ProductDetails({
    required this.product,
    required this.printed,
    required this.quantity,
    required this.value,
    required this.totalLiquid,
    required this.comments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget rowValue(String value) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(value, textAlign: TextAlign.center),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: RequestedAt(printed: printed),
        ),
        const SizedBox(width: 2),
        Expanded(
          flex: 3,
          child: NameAndComment(product: product, comments: comments),
        ),
        if (hasMinWidth(context)) rowValue(value),
        rowValue(quantity),
        rowValue(totalLiquid),
      ],
    );
  }
}
