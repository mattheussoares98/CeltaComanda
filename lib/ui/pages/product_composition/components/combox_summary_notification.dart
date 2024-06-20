import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class ComboxSummaryNotification extends StatefulWidget {
  final String fatherName;
  final List<ProductCompositionViewModel> productsCompositions;
  final double totalPrice;
  const ComboxSummaryNotification({
    required this.fatherName,
    required this.productsCompositions,
    required this.totalPrice,
    super.key,
  });

  @override
  State<ComboxSummaryNotification> createState() =>
      _ComboxSummaryNotificationState();
}

class _ComboxSummaryNotificationState extends State<ComboxSummaryNotification> {
  Widget _titleAndValue({
    required String title,
    required String value,
    Color? valueColor = Colors.black,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    final selectedProducts = widget.productsCompositions
        .where((element) => element.indexOfSelectedChild != null);

    ProductCompositionViewModel? selectedChild;
    final textWidgets = selectedProducts.map((element) {
      if (element.childs?.isEmpty == true) {
        selectedChild = element;
      } else {
        selectedChild = element.childs![element.indexOfSelectedChild!];
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            selectedChild!.ChildName.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (element.commentFather != null)
            CommentRichText(comment: element.commentFather!),
          Row(
            children: [
              _titleAndValue(
                title: "Qtd",
                value: (element.Quantity.toString().toDouble() *
                        productCompositionPresenter.totalComboxQuantity)
                    .toString()
                    .toBrazilianNumber(0),
              ),
              const Expanded(child: Text("X", textAlign: TextAlign.center)),
              _titleAndValue(
                title: "Preço",
                value: productCompositionPresenter
                    .calculateTotalLiquid(product: element)
                    .toString()
                    .toBrazilianNumber()
                    .addBrazilianCoin(),
              ),
              const Expanded(child: Text("=", textAlign: TextAlign.center)),
              _titleAndValue(
                  title: "Total",
                  value: (productCompositionPresenter.calculateTotalLiquid(
                            product: element,
                          ) *
                          productCompositionPresenter.totalComboxQuantity)
                      .toString()
                      .toBrazilianNumber()
                      .addBrazilianCoin(),
                  valueColor: Colors.green),
            ],
          ),
          const Divider(thickness: 0.2),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            widget.fatherName,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const Divider(thickness: 0.2),
          Column(
            children: textWidgets,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PriceAndUpdateProductQuantity(
                showDeleteIcon: false,
                onPressedReduceQuantity:
                    productCompositionPresenter.totalComboxQuantity <= 1
                        ? null
                        : () {
                            setState(() {
                              productCompositionPresenter
                                  .updateComboxQuantity(false);
                            });
                          },
                onPressedAddQuantity: () {
                  setState(() {
                    productCompositionPresenter.updateComboxQuantity(true);
                  });
                },
                productQuantity:
                    productCompositionPresenter.totalComboxQuantity,
                price: widget.totalPrice,
                totalLiquid: productCompositionPresenter.totalComboxQuantity *
                    widget.totalPrice,
                showUpdateProductQuantity: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
