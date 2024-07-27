import 'package:flutter/material.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class TotalPriceCombox extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final Stream<double> totalPriceStream;
  final Function() updateTotalLiquid;
  final int totalProductsQuantity;

  const TotalPriceCombox({
    required this.selectedProduct,
    required this.totalPriceStream,
    required this.updateTotalLiquid,
    required this.totalProductsQuantity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: totalPriceStream,
        builder: (context, snapshot) {
          Future.delayed(Duration.zero, () {
            updateTotalLiquid();
          });

          double totalLiquid = snapshot.data ?? 0;
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
                    (totalProductsQuantity * totalLiquid)
                        .toString()
                        .toBrazilianNumber()
                        .addBrazilianCoin(),
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
