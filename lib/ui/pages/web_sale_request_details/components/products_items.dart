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

          final notChildProducts = groupItems
              .where((p) => p.SaleRequestProductIdOfFather == null)
              .toList();

          return ListView.builder(
            shrinkWrap: true,
            itemCount: notChildProducts.length,
            itemBuilder: (context, index) {
              final product = notChildProducts[index];
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
