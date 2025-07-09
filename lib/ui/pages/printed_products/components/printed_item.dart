import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
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

  Color getColor(int index, PrintedProductsViewModel product) {
    if (product.IsCancelled == "true") {
      return Colors.red;
    } else if (index % 2 == 0) {
      return Theme.of(context).primaryColorLight.withAlpha(10);
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

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
                      if (ScreenSize.hasMinWidth) columnTitle(R.string.price),
                      columnTitle(R.string.quantityAbbreviated),
                      columnTitle(R.string.total),
                    ],
                  ),
                ),
                const Divider(thickness: 0.3),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.printed.Products.toList().length,
                    itemBuilder: (context, index) {
                      final product = widget.printed.Products.toList()[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width /
                                    getItensPerLine(context)) -
                                2,
                            margin: const EdgeInsets.only(right: 2, left: 2),
                            padding: const EdgeInsets.all(8),
                            color: getColor(index, product),
                            child: ProductDetails(
                              printed: widget.printed,
                              product: product,
                              quantity: product.Quantity!,
                              value: (product.TotalLiquid!.toDouble() /
                                      product.Quantity!.toDouble())
                                  .toString()
                                  .toBrazilianNumber(),
                              totalLiquid: product.TotalLiquid!,
                              comments: product.Comments,
                            ),
                          ),
                          if (!ScreenSize.hasMinWidth &&
                              index == widget.printed.Products.length - 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 4),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    if (EnterpriseBuilder
                                            .entity?.canInsertCustomer ==
                                        true)
                                      SizedBox(
                                        height: printedProductsPresenter
                                                    .customerInSaleRequest !=
                                                null
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                        child: const UpdateCustomer(),
                                      ),
                                    const SizedBox(height: 4),
                                    const Expanded(child: TotalByPerson()),
                                  ],
                                ),
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
          if (ScreenSize.hasMinWidth)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (EnterpriseBuilder.entity?.canInsertCustomer == true)
                      SizedBox(
                        height:
                            printedProductsPresenter.customerInSaleRequest !=
                                    null
                                ? MediaQuery.of(context).size.height * 0.3
                                : MediaQuery.of(context).size.height * 0.1,
                        child: const UpdateCustomer(),
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: const TotalByPerson(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
