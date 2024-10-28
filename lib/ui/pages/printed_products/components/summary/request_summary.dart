import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../../../ui/pages/pages.dart';

class RequestSummary extends StatelessWidget {
  const RequestSummary({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: true);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(2),
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
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: printedProductsPresenter.serviceChargeValue <= 0
                  ? SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Subtotal(),
                        const SizedBox(height: 10),
                        ServiceCharge(),
                      ],
                    ),
            ),
            if (printedProductsPresenter.serviceChargeValue > 0)
              VerticalDivider(
                color: Theme.of(context).primaryColorLight,
                thickness: 1,
              ),
            Expanded(
              child: Total(),
            ),
          ],
        ),
      ),
    );
  }
}
