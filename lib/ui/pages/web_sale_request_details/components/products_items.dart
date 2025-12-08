import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/models.dart';
import '../../../helpers/helpers.dart';
import 'components.dart';

class ProductsListFlow extends StatelessWidget {
  final SaleRequestModel saleRequest;

  const ProductsListFlow({
    super.key,
    required this.saleRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = saleRequest.Products!;

    products.sort((a, b) => a.product!.Name.compareTo(b.product!.Name));
    products.sort((a, b) {
      final dateA = a.DateHourOfCreation == null
          ? null
          : DateTime.parse(a.DateHourOfCreation!);
      final dateB = b.DateHourOfCreation == null
          ? null
          : DateTime.parse(b.DateHourOfCreation!);

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateB.compareTo(dateA);
    });

    return ResponsiveListFlow(
        shrinkWrap: true,
        itemCount: saleRequest.Products!.length,
        itemBuilder: (_, index) {
          final product = saleRequest.Products![index];

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: product.Quantity.toString()
                            .toBrazilianNumber(2, true),
                      ),
                      const TextSpan(
                        text: ' x ',
                      ),
                      TextSpan(text: product.product!.Name),
                      if (product.Comments != null)
                        TextSpan(
                          text: ' (${product.Comments!})',
                          style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.red, fontStyle: FontStyle.italic),
                        )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Builder(builder: (context) {
                  final date = DateTime.parse(product.DateHourOfCreation!);
                  return Text(
                    DateFormat(date.day != DateTime.now().day
                            ? "dd/MM HH:mm:ss"
                            : "HH:mm:ss")
                        .format(
                      DateTime.parse(product.DateHourOfCreation!),
                    ),
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleMedium,
                  );
                }),
              ),
            ],
          );
        });
  }
}
