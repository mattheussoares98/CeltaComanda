import 'dart:async';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class PrintedProductsPage extends StatefulWidget {
  final bool? isFixedCommandNumber;
  const PrintedProductsPage(
    this.isFixedCommandNumber, {
    super.key,
  });

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
          title: Text(R.string.requested),
          actions: [
            IconButton(
              onPressed: () async {
                await printedProductsPresenter
                    .loadPrinted(homePresenter.commandNumber!);
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
        body: SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: printedProductsPresenter.printed != null
                    ? PrintedItem(
                        printed: printedProductsPresenter.printed!,
                        formKey: formKey,
                        passwordController: passwordController,
                        personalizedCodeController: personalizedCodeController,
                      )
                    : const SearchDataByCommandNumber(),
              ),
              if (printedProductsPresenter.printed != null)
                RequestSummary(
                  requestUserAndPassword: true,
                  printed: printedProductsPresenter.printed!,
                  commandNumber: homePresenter.commandNumber!.toInt(),
                  loadPrintedAgain: () async {
                    await printedProductsPresenter
                        .loadPrinted(homePresenter.commandNumber!);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
