import 'dart:async';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../components/components.dart';
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
    const totalPriceContainerHeight = 50.0;

    PrintedProductsPresenter printedProductsPresenter = Provider.of(context,
        listen:
            true); //pra atualizar corretamente quando remove o produto do carrinho
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

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
      onPopInvoked: (_) {
        printedProductsPresenter.doOnClosePage();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                await printedProductsPresenter.loadPrinted(
                  homePresenter.commandNumber!,
                );
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: totalPriceContainerHeight),
                child: SingleChildScrollView(
                  child: printedProductsPresenter.printedProducts != null
                      ? PrintedItem(
                          printed: printedProductsPresenter.printedProducts!,
                          formKey: formKey,
                          passwordController: passwordController,
                          personalizedCodeController:
                              personalizedCodeController,
                        )
                      : SearchDataByCommandNumber(
                          homePresenter: homePresenter,
                          emptyMessage: homePresenter.commandNumber == null
                              ? "Consulte alguma comanda para visualizar os produtos solicitados"
                              : "Não há produtos solicitados nessa comanda",
                          loadCommandData: () async {
                            await homePresenter.loadCommandData(
                              menuPresenter: menuPresenter,
                              printedProductsPresenter:
                                  printedProductsPresenter,
                              cartPresenter: cartPresenter,
                              commentsPresenter: commentsPresenter,
                            );
                          },
                        ),
                ),
              ),
              if (printedProductsPresenter.printedProducts != null)
                const RequestSummary(
                  totalPriceContainerHeight: totalPriceContainerHeight,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
