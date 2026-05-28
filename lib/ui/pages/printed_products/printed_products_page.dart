import 'dart:async';

import 'package:clean_celta_mobile/presentation/helpers/app_platform.dart';
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
  PrintedProductsPresenter? printedProductsPresenter;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    alertMessageSubscription?.cancel();
    personalizedCodeController.dispose();
    passwordController.dispose();

    printedProductsPresenter?.disposePrinterHandler();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        printedProductsPresenter = Provider.of(context, listen: false);
        HomePresenter homePresenter = Provider.of(context, listen: false);

        printedProductsPresenter?.initPrinterResultHandler(
          homePresenter: homePresenter,
          closePageForOldPrintWay: () {},
        );
      }
    });
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
          title: FittedBox(
            child: Text(R.string.requested),
          ),
          actions: [
            if (activePlatform.isPaymentPlatform)
              const PrintPrintedProductsButton(),
            const LoadPrintedProductsAgainButton(),
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
