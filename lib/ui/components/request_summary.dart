import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../ui/pages/pages.dart';

class RequestSummary extends StatelessWidget {
  final double totalPriceContainerHeight;
  const RequestSummary({
    required this.totalPriceContainerHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: true);

    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: totalPriceContainerHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color.fromARGB(255, 220, 218, 218)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color(0x33000000),
              offset: Offset(-3, -1),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 30),
              Text(
                "${printedProductsPresenter.printedProducts!.TotalLiquid} R\$",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
