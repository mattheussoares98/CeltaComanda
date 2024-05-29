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
    required int flex,
    required String title,
    required String value,
    Color? valueColor = Colors.black,
  }) {
    return Expanded(
      flex: flex,
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

    final textWidgets = selectedProducts.map((element) {
      ProductCompositionViewModel selectedChild;

      if (element.childs?.isEmpty == true) {
        selectedChild = element;
      } else {
        selectedChild = element.childs![element.indexOfSelectedChild!];
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            selectedChild.ChildName.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            selectedChild.PluChild.toString(),
          ),
          if (element.commentFather != null)
            CommentRichText(comment: element.commentFather!),
          Row(
            children: [
              _titleAndValue(
                flex: 2,
                title: "Qtd",
                value: (element.Quantity.toString().toDouble() *
                        productCompositionPresenter.totalComboxQuantity)
                    .toString()
                    .toBrazilianNumber(0),
              ),
              const Expanded(
                  flex: 1, child: Text("X", textAlign: TextAlign.center)),
              _titleAndValue(
                flex: 4,
                title: "Preço",
                value: (element.SalePrice.toString().toDouble())
                    .toString()
                    .toBrazilianNumber()
                    .addBrazilianCoin(),
              ),
              const Expanded(child: Text("+", textAlign: TextAlign.center)),
              _titleAndValue(
                flex: 5,
                title: "Acréscimo",
                value: element.IncrementValue.toString()
                    .toBrazilianNumber()
                    .addBrazilianCoin(),
              ),
              const Expanded(child: Text("=", textAlign: TextAlign.center)),
              _titleAndValue(
                  flex: 5,
                  title: "Total",
                  value: ((element.SalePrice.toString().toDouble() *
                              productCompositionPresenter.totalComboxQuantity) +
                          element.IncrementValue.toString().toDouble())
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
