import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../../../data/models/models.dart';
import '../../../helpers/helpers.dart';

class ProductsItems extends StatelessWidget {
  final List<ConcSaleRequestProductModel> products;
  final bool isPreparingColumn;

  const ProductsItems({
    super.key,
    required this.products,
    required this.isPreparingColumn,
  });

  Color _getGroupColor(int index) {
    List<Color> colors = [
      Colors.yellowAccent.withAlpha(50),
      Colors.blue.withAlpha(50),
      Colors.orange.withAlpha(50),
      Colors.purple.withAlpha(50),
      Colors.lightGreen.withAlpha(50),
      Colors.pink.withAlpha(50),
      Colors.teal.withAlpha(50),
      Colors.greenAccent.withAlpha(50),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    products.sort((a, b) => a.ProductName!.compareTo(b.ProductName!));
    products.sort((a, b) {
      final dateA = a.DateHourOfCreation;
      final dateB = b.DateHourOfCreation;

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateA.compareTo(dateB);
    });

    final grouped = groupBy(products, (p) => p.DateHourOfCreation);
    final groupKeys = grouped.keys.toList();

    return ListView.builder(
        shrinkWrap: true,
        itemCount: groupKeys.length,
        itemBuilder: (_, groupIndex) {
          final dateKey = groupKeys[groupIndex];
          final groupItems = grouped[dateKey]!;
          final groupColor = _getGroupColor(groupIndex);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: groupColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: groupColor, style: BorderStyle.solid),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: groupItems.length,
              itemBuilder: (context, index) {
                final product = groupItems[index];
                final children = products
                    .where((e) =>
                        e.SaleRequestProductIdOfFather?.toInt() ==
                        product.SaleRequestProductId)
                    .toList();

                return Column(
                  children: [
                    ProductInformations(
                        product: product, showDateHourOfCreation: index == 0),
                    ...children.map((child) => ProductInformations(
                        product: child, showDateHourOfCreation: false)),
                  ],
                );
              },
            ),
          );
        });
  }
}

class ProductInformations extends StatelessWidget {
  final ConcSaleRequestProductModel product;
  final bool showDateHourOfCreation;
  const ProductInformations({
    super.key,
    required this.product,
    required this.showDateHourOfCreation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productIsChild = product.SaleRequestProductIdOfFather != null;
    final formatter = DateFormat('HH:mm:ss');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.titleSmall?.copyWith(
                fontStyle: productIsChild ? FontStyle.italic : FontStyle.normal,
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
                TextSpan(
                    text: product.ProductName ??
                        (productIsChild ? 'childName' : 'productName')),
                if (product.ProductIsFatherComposition == true) ...[
                  TextSpan(
                    text: ' (${R.string.combox})',
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
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
        if (product.DateHourOfCreation != null && showDateHourOfCreation)
          Text(formatter.format(product.DateHourOfCreation!)),
      ],
    );
  }
}
