import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class PrintedItem extends StatefulWidget {
  final PrintedViewModel printed;
  final GlobalKey<FormState> formKey;
  final TextEditingController personalizedCodeController;
  final TextEditingController passwordController;

  const PrintedItem({
    required this.printed,
    required this.formKey,
    required this.personalizedCodeController,
    required this.passwordController,
    super.key,
  });

  @override
  State<PrintedItem> createState() => _PrintedItemState();
}

class _PrintedItemState extends State<PrintedItem> {
  final double rightMargin = 2;

  Widget columnTitle(String name, [int flex = 1]) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      columnTitle(R.string.time),
                      columnTitle(R.string.productsAndComments, 3),
                      if (hasMinWidth(context)) columnTitle(R.string.price),
                      columnTitle(R.string.quantityAbbreviated),
                      columnTitle(R.string.total),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.3,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.printed.Products.length,
                    itemBuilder: (context, index) {
                      final product = widget.printed.Products[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width /
                                    getItensPerLine(context)) -
                                rightMargin,
                            margin: const EdgeInsets.only(
                                bottom: 4, right: 2, left: 2),
                            padding: const EdgeInsets.all(8),
                            child: ProductDetails(
                              printed: widget.printed,
                              product: product,
                              quantity: product.Quantity,
                              value: (product.TotalLiquid.toDouble() /
                                      product.Quantity.toDouble())
                                  .toString()
                                  .toBrazilianNumber(),
                              totalLiquid: product.TotalLiquid,
                              comments: product.Comments,
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 0.1,
                          ),
                          if (!hasMinWidth(context) &&
                              index == widget.printed.Products.length - 1)
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                child: UpdateTotalByPerson(),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (hasMinWidth(context))
            const Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UpdateTotalByPerson(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
