import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../pages.dart';

class ComboxSummaryNotification extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final selectedProducts = productsCompositions
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                element.SalePrice.toString()
                    .toBrazilianNumber()
                    .addBrazilianCoin(),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (element.IncrementValue.toString().toDouble() > 0)
                Text(
                  "Acréscimo: ${element.IncrementValue.toString().toBrazilianNumber().addBrazilianCoin()}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            fatherName,
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
              Text(
                "Total: ${totalPrice.toString().toBrazilianNumber().addBrazilianCoin()}",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
