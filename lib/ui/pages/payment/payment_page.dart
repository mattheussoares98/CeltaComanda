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
  StreamSubscription? printedLoadingSubscription;
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  PaymentPresenter? paymentPresenter;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    printedLoadingSubscription?.cancel();
    paymentPresenter?.disposePaymentResultHandler();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        paymentPresenter = Provider.of(context, listen: false);
        PrintedProductsPresenter printedProductsPresenter =
            Provider.of(context, listen: false);
        HomePresenter homePresenter = Provider.of(context, listen: false);
        _getAlreadyPaid(paymentPresenter!);

        paymentPresenter?.initPaymentResultHandler(
          homePresenter,
          printedProductsPresenter,
        );
      }
    });
  }

  Future<void> _getAlreadyPaid(PaymentPresenter paymentPresenter) async {
    await paymentPresenter.getAndUpdateAlreadyPaidCommand();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);

    printedLoadingSubscription?.cancel();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, paymentPresenter.isLoadingStream);
    printedLoadingSubscription =
        handleLoading(context, printedProductsPresenter.isLoadingStream);
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
        title: Text(R.string.pay),
        actions: [
          IconButton(
            onPressed: () async {
              await printedProductsPresenter.loadPrinted(homePresenter);
            },
            icon: Row(
              children: [
                if (homePresenter.commandNumber != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      "${R.string.command} ${homePresenter.commandNumber!.toInt()}",
                      style: TextStyle(fontSize: getStringSize(context)),
                    ),
                  ),
                const Icon(Icons.refresh),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (printedProductsPresenter.printedProducts != null &&
                !paymentPresenter.commandAlreadyPaid)
              const PaymentButtons(),
            if (paymentPresenter.commandAlreadyPaid)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: LiquidateCommand(
                  callSetState: () {
                    setState(() {});
                  },
                ),
              ),
            if (printedProductsPresenter.printedProducts == null &&
                    !paymentPresenter.commandAlreadyPaid ||
                !homePresenter.isFixedCommandNumber)
              const SearchDataByCommandNumber(),
          ],
        ),
      ),
    );
  }
}
