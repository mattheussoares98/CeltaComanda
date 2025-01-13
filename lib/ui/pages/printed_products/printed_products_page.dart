import 'dart:async';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class PrintedProductsPage extends StatefulWidget {
  const PrintedProductsPage({super.key});

  @override
  State<PrintedProductsPage> createState() => _PrintedProductsPageState();
}

class _PrintedProductsPageState extends State<PrintedProductsPage>
    with UIErrorManager, LoadingManager, AlertMessageManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? alertMessageSubscription;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController personalizedCodeController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    alertMessageSubscription?.cancel();
    personalizedCodeController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context,
        listen:
            true); //pra atualizar corretamente quando remove o produto do carrinho
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    alertMessageSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, printedProductsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, printedProductsPresenter.mainErrorStream);
    alertMessageSubscription = handleAlertMessage(
        context, printedProductsPresenter.alertMessageStream);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        printedProductsPresenter.doOnClosePage();
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onLongPress: () async {
              await printedProductsPresenter.newPrintProducts(
                closePage: () {
                  Navigator.of(context).pop();
                },
              );
            },
            child: FittedBox(
              child: Text(R.string.requested),
            ),
          ),
          actions: [
            if (homePresenter.isGeneratingVersionToRede)
              PrintPrintedProductsButton(),
            LoadPrintedProductsAgainButton(),
          ],
        ),
        body: SafeArea(
          child: SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: printedProductsPresenter.printed != null
                      ? PrintedItem(
                          printed: printedProductsPresenter.printed!,
                          formKey: formKey,
                          passwordController: passwordController,
                          personalizedCodeController:
                              personalizedCodeController,
                        )
                      : const SearchDataByCommandNumber(),
                ),
                if (printedProductsPresenter.printed != null)
                  RequestSummary(
                    showRemoveServiceChargeButton: false,
                    requestUserAndPassword: true,
                    printed: printedProductsPresenter.printed!,
                    commandNumber:
                        homePresenter.commandEntity!.commandNumber!.toInt(),
                    loadPrintedAgain: () async {
                      await printedProductsPresenter.loadPrinted(
                          homePresenter.commandEntity!.commandNumber!);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
