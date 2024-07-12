import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class ComboxSummaryNotification extends StatefulWidget {
  final String selectedComboxProduct;
  final List<ProductCompositionViewModel> productsCompositions;
  final double totalPrice;
  const ComboxSummaryNotification({
    required this.selectedComboxProduct,
    required this.productsCompositions,
    required this.totalPrice,
    super.key,
  });

  @override
  State<ComboxSummaryNotification> createState() =>
      _ComboxSummaryNotificationState();
}

class _ComboxSummaryNotificationState extends State<ComboxSummaryNotification> {
  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    final selectedProducts = widget.productsCompositions
        .where((element) => element.indexOfSelectedChild != null);

    ProductCompositionViewModel? selectedChild;
    final widgets = selectedProducts.map((selectedProduct) {
      if (selectedProduct.childs?.isEmpty == true) {
        selectedChild = selectedProduct;
      } else {
        selectedChild = selectedProduct.childs![selectedProduct.indexOfSelectedChild!];
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ImageWidget(
                ean: null,
                plu: selectedChild!.PluChild!,
                height: 70,
                width: 70,
              ),
              Expanded(
                child: Text(
                  selectedChild!.ChildName.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "${(selectedProduct.Quantity.toString().toDouble() * productCompositionPresenter.totalComboxQuantity).toString().toBrazilianNumber(0)} qtd",
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          if (selectedProduct.commentFather != null)
            CommentRichText(comment: selectedProduct.commentFather!),
          const Divider(thickness: 0.2, height: 3),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            widget.selectedComboxProduct,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const Divider(thickness: 0.2),
          Column(
            children: widgets,
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PriceAndUpdateProductQuantity(
                showItemPrice: false,
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
