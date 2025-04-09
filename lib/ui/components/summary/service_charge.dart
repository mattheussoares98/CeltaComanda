import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import '../../helpers/helpers.dart';
import '../../pages/pages.dart';

class ServiceCharge extends StatefulWidget {
  final PrintedViewModel printed;
  final Future<void> Function() loadPrintedAgain;
  final bool validateUserAndPassword;
  final bool showRemoveServiceChargeButton;
  final int commandNumber;
  const ServiceCharge({
    required this.printed,
    required this.loadPrintedAgain,
    required this.validateUserAndPassword,
    required this.showRemoveServiceChargeButton,
    required this.commandNumber,
    super.key,
  });

  @override
  State<ServiceCharge> createState() => _ServiceChargeState();
}

class _ServiceChargeState extends State<ServiceCharge> {
  Future<void> removeCharge(
    PrintedProductsPresenter printedProductsPresenter,
    CancelProductsPresenter cancelProductsPresenter,
  ) async {
    await printedProductsPresenter.removeServiceCharge(
      commandNumber: widget.commandNumber.toString(),
      printed: widget.printed,
    );

    if (widget.validateUserAndPassword) {
      await cancelProductsPresenter.loadProducts(widget.commandNumber);
    } else {
      await widget.loadPrintedAgain();
    }
  }

  void openRemoveServiceChargeDialog(
    PrintedProductsPresenter printedProductsPresenter,
    CancelProductsPresenter cancelProductsPresenter,
  ) {
    if (widget.validateUserAndPassword == false) {
      notificationDialog(
          context: context,
          titleMessage: R.string.removeServiceCharge,
          content: null,
          showCancelAndConfirmMessage: true,
          onPress: () async {
            await removeCharge(
                printedProductsPresenter, cancelProductsPresenter);
          });
    } else {
      notificationDialog(
        context: context,
        titleMessage: R.string.configurations,
        showCancelAndConfirmMessage: false,
        content: ConfigurationsDialogPage(),
        onPress: () async {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    CancelProductsPresenter cancelProductsPresenter =
        Provider.of(context, listen: false);

    return GestureDetector(
      onLongPress: () async {
        openRemoveServiceChargeDialog(
            printedProductsPresenter, cancelProductsPresenter);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: Text(
                R.string.serviceCharge,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: StringSize.size),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    printedProductsPresenter
                        .getServiceChargeValue(widget.printed)
                        .toString()
                        .toBrazilianNumber()
                        .addBrazilianCoin(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: StringSize.size,
                    ),
                  ),
                  if (widget.showRemoveServiceChargeButton)
                    InkWell(
                      onTap: () {
                        openRemoveServiceChargeDialog(
                            printedProductsPresenter, cancelProductsPresenter);
                      },
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              R.string.removeServiceCharge,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: StringSize.size,
                              ),
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
