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
  final formKey = GlobalKey<FormState>();
  final paymentController = TextEditingController();
  final paymentFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    printedLoadingSubscription?.cancel();
    paymentPresenter?.disposePaymentResultHandler();
    paymentController.dispose();
    paymentFocusNode.dispose();
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

        paymentPresenter?.initPaymentResultHandler(
          homePresenter,
          printedProductsPresenter,
        );

        paymentController.text =
            printedProductsPresenter.totalLiquid.toString().toBrazilianNumber();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    HomePresenter homePresenter = Provider.of(context, listen: false);
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PaymentDetails(),
              if (printedProductsPresenter.printedProducts != null)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: WriteAmoutValueToPay(
                        formKey: formKey,
                        paymentController: paymentController,
                        paymentFocusNode: paymentFocusNode,
                      ),
                    ),
                    PaymentButtons(
                      paymentController: paymentController,
                    ),
                  ],
                ),
              if (paymentPresenter.totalPaidValue ==
                  printedProductsPresenter.totalLiquid)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: LiquidateCommand(
                    callSetState: () {
                      setState(() {});
                    },
                  ),
                ),
              if (printedProductsPresenter.printedProducts == null ||
                  !homePresenter.isFixedCommandNumber)
                const SearchDataByCommandNumber(),
            ],
          ),
        ),
      ),
    );
  }
}
