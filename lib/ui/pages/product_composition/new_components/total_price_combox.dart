import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class TotalPriceCombox extends StatelessWidget {
  final FathersItems fatherItems;

  const TotalPriceCombox({
    super.key,
    required this.fatherItems,
  });

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return StreamBuilder<double>(
        stream: productCompositionPresenter.totalPriceComboxStream,
        builder: (context, snapshot) {
          Future.delayed(Duration.zero, () {
            productCompositionPresenter.updateTotalLiquidCombox(
                fatherItems.selectedProduct.childsComposition!);
          });

          double total = snapshot.data ?? 0;
          return Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    total.toString().toBrazilianNumber().addBrazilianCoin(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: getStringSize(context) * 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
