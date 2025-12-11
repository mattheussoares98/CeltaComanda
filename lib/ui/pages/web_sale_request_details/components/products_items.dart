import 'package:flutter/material.dart';

import '../../../../data/models/models.dart';
import '../../../helpers/helpers.dart';
import 'components.dart';

class ProductsListFlow extends StatelessWidget {
  final ConcSaleRequestModel saleRequest;

  const ProductsListFlow({
    super.key,
    required this.saleRequest,
  });

  @override
  Widget build(BuildContext context) {
    final products = saleRequest.Products.where(
        (e) => e.SaleRequestProductIdOfFather == null).toList();

    // products.sort((a, b) => a.ProductName!.compareTo(b.ProductName!));
    // products.sort((a, b) {
    //   final dateA = a.DateHourOfCreation == null
    //       ? null
    //       : DateTime.parse(a.DateHourOfCreation!);
    //   final dateB = b.DateHourOfCreation == null
    //       ? null
    //       : DateTime.parse(b.DateHourOfCreation!);

    //   if (dateA == null && dateB == null) return 0;
    //   if (dateA == null) return 1;
    //   if (dateB == null) return -1;

    //   return dateB.compareTo(dateA);
    // });

    return ResponsiveListFlow(
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ProductInformations(product: product),
                  ),
                ],
              ),
              Builder(builder: (context) {
                final childs = saleRequest.Products.where((e) =>
                    e.SaleRequestProductIdOfFather?.toInt() ==
                    product.SaleRequestProductId).toList();
                return ListView.builder(
                  itemCount: childs.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final child = childs[index];

                    return ProductInformations(product: child);
                  },
                );
              }),
              if (index < products.length - 1)
                const Divider(
                  thickness: 0.1,
                  height: 8,
                ),
            ],
          );
        });
  }
}

class ProductInformations extends StatelessWidget {
  final ConcSaleRequestProductModel product;
  const ProductInformations({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final productIsChild = product.SaleRequestProductIdOfFather != null;

    return Row(
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
        const Text('Horário de solicitação'),
      ],
    );
  }
}
