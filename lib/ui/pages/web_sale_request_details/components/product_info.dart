import 'package:flutter/material.dart';

import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';

class ProductInfo extends StatelessWidget {
  final DeliveryControlEntity deliveryControl;
  final DeliveryProductControlEntity product;
  const ProductInfo({
    super.key,
    required this.product,
    required this.deliveryControl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productIsChild = product.ProductIdOfFather != null;
    final canceledDecoration = TextDecoration.combine([
      if (product.IsCancelled == true || deliveryControl.IsCancelled == true)
        TextDecoration.lineThrough,
    ]);

    final productIsLate = product.deliveryStatusLate == DeliveryStatusLate.late;

    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.titleSmall?.copyWith(
            fontStyle: productIsChild ? FontStyle.italic : FontStyle.normal,
            decoration: canceledDecoration,
          ),
          children: [
            if (productIsChild)
              const TextSpan(
                text: '  - ',
              ),
            TextSpan(
              text: product.Quantity.toString().toBrazilianNumber(2, true),
            ),
            const TextSpan(
              text: ' x ',
            ),
            TextSpan(text: product.ProductName),
            if (product.ProductIsFatherComposition == true) ...[
              TextSpan(
                text: ' (${R.string.combox})',
                style: TextStyle(
                  color: productIsLate ? Colors.white : Colors.red,
                ),
              ),
            ],
            if (product.Comments?.isNotEmpty ?? false)
              TextSpan(
                text: ' (${product.Comments!})',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: productIsLate ? Colors.white : Colors.red,
                  fontStyle: FontStyle.italic,
                  decoration: canceledDecoration,
                ),
              ),
            if (product.IsCancelled == true)
              TextSpan(
                text: " ${R.string.canceled}",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: productIsLate ? Colors.white : Colors.red,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              )
          ],
        ),
      ),
    );
  }
}
