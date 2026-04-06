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
    with LoadingManager, UIErrorManager, UpdateScreenManager {
  StreamSubscription? printedLoadingSubscription;
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? printedErrorSubscription;
  StreamSubscription? updateScrrenSubscription;
  PaymentPresenter? paymentPresenter;
  final formKey = GlobalKey<FormState>();
  final paymentController = TextEditingController();
  final paymentFocusNode = FocusNode();
  final cpfCnpjController = TextEditingController();
  final cpfCnpjFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    printedErrorSubscription?.cancel();
    printedLoadingSubscription?.cancel();
    updateScrrenSubscription?.cancel();
    paymentPresenter?.disposePaymentResultHandler();
    paymentController.dispose();
    paymentFocusNode.dispose();
    cpfCnpjController.dispose();
    cpfCnpjFocusNode.dispose();
    paymentPresenter?.changeCpfCnpj(null);
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

        paymentPresenter?.initRedePaymentResultHandler(
          homePresenter: homePresenter,
          printedProductsPresenter: printedProductsPresenter,
          showErrorMessageReturnedByBs: (error) {
            snackBarMessage(context, error, backgroundColor: Colors.red);
          },
          showSuccessAndCloseUntilHomePage: () {
            Navigator.of(context).popUntil(
              (route) => route.isFirst,
            );
            snackBarMessage(
              context,
              R.string.liquidateCommandSucceeds,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            );
          },
        );

        paymentController.text = paymentPresenter!
            .getTotalPendingValue(printedProductsPresenter)
            .toString()
            .replaceAll(RegExp(r'\.'), ',');

        if (paymentPresenter?.cpfCnpj != null) {
          cpfCnpjController.text = paymentPresenter!.cpfCnpj.toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);
    final totalLiquid = printedProductsPresenter
        .getTotalLiquid(printedProductsPresenter.printed);
    final pendingValue =
        paymentPresenter.getTotalPendingValue(printedProductsPresenter);

    printedLoadingSubscription?.cancel();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    updateScrrenSubscription?.cancel();
    printedErrorSubscription?.cancel();

    printedErrorSubscription = handleMainError(
      context,
      printedProductsPresenter.mainErrorStream,
    );
    loadingSubscription =
        handleLoading(context, paymentPresenter.isLoadingStream);
    printedLoadingSubscription =
        handleLoading(context, printedProductsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, paymentPresenter.mainErrorStream);
    updateScrrenSubscription = handleUpdateScreen(
      context,
      paymentPresenter.updateScreenStream,
      () {
        Future.delayed(Duration.zero, () {
          if (mounted) {
            paymentController.clear();
            setState(() {});
          }
        });
      },
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (paymentPresenter.successfulPayments.isNotEmpty ||
            paymentPresenter.totalPaidValue > 0) {
          notificationDialog(
            context: context,
            titleMessage: R.string.msgClearConfirmedPayments,
            content: Text(
              R.string.msgConfirmClearTotalPaid,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: StringSize.size),
            ),
            onPress: () async {
              paymentPresenter.clearPayments();
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          );
        } else {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(R.string.pay),
          actions: [
            IconButton(
              onPressed: () async {
                await printedProductsPresenter
                    .loadPrinted(homePresenter.commandEntity!.commandNumber!);
              },
              icon: Row(
                children: [
                  if (homePresenter.commandEntity?.commandNumber != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        "${R.string.command} ${homePresenter.commandEntity!.commandNumber!.toInt()}",
                        style: TextStyle(fontSize: StringSize.size),
                      ),
                    ),
                  const Icon(Icons.refresh),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pendingValue > 0)
                    PaymentDetails(
                      totalLiquid: totalLiquid,
                      totalPaidValue: paymentPresenter.totalPaidValue,
                      totalPendingValue: pendingValue,
                    ),
                  if (printedProductsPresenter.printed != null &&
                      pendingValue > 0)
                    Column(
                      children: [
                        if (homePresenter.isGeneratingVersionToGetNet ||
                            homePresenter.isGeneratingVersionToRede)
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                WriteAmoutValueToPay(
                                  paymentController: paymentController,
                                  paymentFocusNode: paymentFocusNode,
                                  cpfCnpjFocusNode: cpfCnpjFocusNode,
                                ),
                                WriteCpfCnpjField(
                                  formKey: formKey,
                                  cpfCnpjController: cpfCnpjController,
                                  cpfCnpjFocusNode: cpfCnpjFocusNode,
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: PaymentButtons(
                            paymentController: paymentController,
                            formKey: formKey,
                          ),
                        ),
                      ],
                    ),
                  if (paymentPresenter.totalPaidValue.toStringAsFixed(2) ==
                          totalLiquid.toStringAsFixed(2) &&
                      totalLiquid > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: LiquidateCommand(
                        callSetState: () {
                          setState(() {});
                        },
                      ),
                    ),
                  if (pendingValue > 0) const Divider(height: 40),
                  const TotalByPerson(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
