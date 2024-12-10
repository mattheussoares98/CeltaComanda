import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/pages.dart';
import '../components.dart';

class RequestSummary extends StatelessWidget {
  final PrintedViewModel printed;
  final Future<void> Function() loadPrintedAgain;
  final bool requestUserAndPassword;
  final bool showRemoveServiceChargeButton;
  final int commandNumber;
  const RequestSummary({
    required this.printed,
    required this.loadPrintedAgain,
    required this.requestUserAndPassword,
    required this.showRemoveServiceChargeButton,
    required this.commandNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    double serviceChargeValue =
        printedProductsPresenter.getServiceChargeValue(printed);
    double totalLiquid = printedProductsPresenter.getTotalLiquid(printed);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: serviceChargeValue <= 0
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Subtotal(
                          totalLiquid:
                              printedProductsPresenter.getSubtotal(printed)),
                      const SizedBox(height: 10),
                      ServiceCharge(
                        printed: printed,
                        loadPrintedAgain: loadPrintedAgain,
                        validateUserAndPassword: requestUserAndPassword,
                        commandNumber: commandNumber,
                        showRemoveServiceChargeButton:
                            showRemoveServiceChargeButton,
                      ),
                    ],
                  ),
          ),
          if (serviceChargeValue > 0)
            VerticalDivider(
              color: Theme.of(context).primaryColorLight,
              thickness: 1,
            ),
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Total(totalLiquid: totalLiquid),
          ),
        ],
      ),
    );
  }
}
