import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../../domain/entities/entities.dart';
import '../../../helpers/helpers.dart';
import 'components.dart';

class ProductsItems extends StatelessWidget {
  final List<PrintedProductsEntity> products;
  final bool isPreparingColumn;
  final TardyStatus tardyStatus;

  const ProductsItems({
    super.key,
    required this.products,
    required this.isPreparingColumn,
    required this.tardyStatus,
  });

  @override
  Widget build(BuildContext context) {
    products.sort((a, b) => a.Product!.Name.compareTo(b.Product!.Name));
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
                    product: product,
                    tardyStatus: tardyStatus,
                    showDateHourOfCreation: index == 0,
                    isCancelled: product.IsCancelled == true,
                  ),
                  ...children.map((child) => ProductInformations(
                        product: child,
                        tardyStatus: tardyStatus,
                        showDateHourOfCreation: false,
                        isCancelled: product.IsCancelled == true,
                      )),
                ],
              );
            },
          );
        });
  }
}

class ProductInformations extends StatelessWidget {
  final PrintedProductsEntity product;
  final bool showDateHourOfCreation;
  final bool isCancelled;
  final TardyStatus tardyStatus;
  const ProductInformations({
    super.key,
    required this.product,
    required this.showDateHourOfCreation,
    required this.isCancelled,
    required this.tardyStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productIsChild = product.SaleRequestProductIdOfFather != null;
    final canceledDecoration = TextDecoration.combine([
      if (product.IsCancelled == true || isCancelled)
        TextDecoration.lineThrough,
    ]);

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
            TextSpan(
                text: product.Product?.Name ??
                    (productIsChild ? 'childName' : 'productName')),
            if (product.ProductIsFatherComposition == true) ...[
              TextSpan(
                text: ' (${R.string.combox})',
                style: TextStyle(
                  color: tardyStatus == TardyStatus.late
                      ? Colors.white
                      : Colors.red,
                ),
              ),
            ],
            if (product.Comments != null)
              TextSpan(
                text: ' (${product.Comments!})',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: tardyStatus == TardyStatus.late
                      ? Colors.white
                      : Colors.red,
                  fontStyle: FontStyle.italic,
                  decoration: canceledDecoration,
                ),
              ),
            if (product.IsCancelled == true)
              TextSpan(
                text: " ${R.string.canceled}",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: tardyStatus == TardyStatus.late
                      ? Colors.white
                      : Colors.red,
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
