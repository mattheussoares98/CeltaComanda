import 'dart:async';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class PrintedProductsPage extends StatefulWidget {
  const PrintedProductsPage({
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

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    alertMessageSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Scaffold(
      drawer: drawer(
        context: context,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: const Color(0xFFF1F5F8),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: [
            SearchCommandIcon(
              loadCommandData: () async {
                await printedProductsPresenter.loadCommandData(
                  printedProductsPresenter: printedProductsPresenter,
                  cartPresenter: cartPresenter,
                  menuPresenter: menuPresenter,
                  homePresenter: homePresenter,
                  clearPermissionToCancelProducts: true,
                  isRemovingProduct: false,
                );
                printedProductsPresenter.updateCanCancelProducts(false);
              },
            )
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (homePresenter.commandNumber != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Comanda ${homePresenter.commandNumber!}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  loadingSubscription?.cancel();
                  mainErrorSubscription?.cancel();
                  alertMessageSubscription?.cancel();

                  loadingSubscription = handleLoading(
                      context, printedProductsPresenter.isLoadingStream);
                  mainErrorSubscription = handleMainError(
                      context, printedProductsPresenter.mainErrorStream);
                  alertMessageSubscription = handleAlertMessage(
                      context, printedProductsPresenter.alertMessageStream);

                  if (printedProductsPresenter.printedProducts != null) {
                    return PrintedItem(
                      printed: printedProductsPresenter.printedProducts!,
                    );
                  }
                  return SearchDataByCommandNumber(
                    homePresenter: homePresenter,
                    emptyMessage: homePresenter.commandNumber == null
                        ? "Consulte alguma comanda para visualizar os produtos solicitados"
                        : "Não há produtos solicitados nessa comanda",
                    loadCommandData: () async {
                      await printedProductsPresenter.loadCommandData(
                        printedProductsPresenter: printedProductsPresenter,
                        cartPresenter: cartPresenter,
                        menuPresenter: menuPresenter,
                        homePresenter: homePresenter,
                        clearPermissionToCancelProducts: true,
                        isRemovingProduct: false,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
