import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../../components/components.dart';
import '../pages.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  void initState() {
    super.initState();
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    _getAlreadyPaid(paymentPresenter);
  }

  Future<void> _getAlreadyPaid(PaymentPresenter paymentPresenter) async {
    await paymentPresenter.getAndUpdateAlreadyPaidCommand();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: true);
    HomePresenter homePresenter = Provider.of(context, listen: true);
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, paymentPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, paymentPresenter.mainErrorStream);

    return Scaffold(
      drawer: drawer(
        context: context,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (printedProductsPresenter.printedProducts != null &&
              !paymentPresenter.commandAlreadyPaid)
            const PaymentButtons(),
          if (paymentPresenter.commandAlreadyPaid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: LiquidateSaleRequest(
                callSetState: () {
                  setState(() {});
                },
              ),
            ),
          if (printedProductsPresenter.printedProducts == null ||
              printedProductsPresenter.printedProducts!.TotalLiquid
                          .toDouble() ==
                      0 &&
                  !paymentPresenter.commandAlreadyPaid)
            SearchDataByCommandNumber(
              homePresenter: homePresenter,
              emptyMessage: homePresenter.commandNumber != null
                  ? R.string.msgCommandDontHaveOpenValues
                  : R.string.msgSearchCommandToPay,
              loadCommandData: () async {
                await paymentPresenter.getTotalValue(
                  homePresenter: homePresenter,
                  cartPresenter: cartPresenter,
                  printedProductsPresenter: printedProductsPresenter,
                  menuPresenter: menuPresenter,
                  expansibleGroupFromProductPresenter:
                      expansibleGroupFromProductPresenter,
                );
              },
            ),
        ],
      ),
    );
  }
}
