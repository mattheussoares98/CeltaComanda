import 'package:flutter/material.dart';

import '../../pages.dart';
import '../../../../ui/helpers/helpers.dart';

class ProductDetails extends StatelessWidget {
  final PrintedProductsViewModel product;
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

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RequestedAt(printedProduct: product),
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
        ),
        if (product.childs.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: product.childs.length,
            itemBuilder: (context, index) {
              final child = product.childs[index];

              return Row(
                children: [
                  Expanded(child: SizedBox()),
                  Expanded(
                    flex: hasMinWidth(context) ? 7 : 6,
                    child: Wrap(
                      children: [
                        const SizedBox(width: 2),
                        RichText(
                          text: TextSpan(
                            text: child.Product.Name,
                            style: TextStyle(
                              fontSize: getStringSize(context) * 0.9,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                            children: child.Comments == null
                                ? []
                                : <TextSpan>[
                                    TextSpan(
                                      text: "   (${child.Comments})",
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontStyle: FontStyle.italic,
                                        fontSize: getStringSize(context) * 0.9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )
      ],
    );
  }
}
