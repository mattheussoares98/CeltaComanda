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
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Scaffold(
      drawer: drawer(
        context: context,
        expansibleGroupsPresenter: expansibleGroupsPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        actions: [
          SearchCommandIcon(
            loadCommandData: () async {
              await printedProductsPresenter.loadCommandData(
                commandNumber: homePresenter.commandNumber!,
                printedProductsPresenter: printedProductsPresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
                expansibleGroupsPresenter: expansibleGroupsPresenter,
                homePresenter: homePresenter,
                clearPermissionToCancelProducts: true,
              );
              printedProductsPresenter.updateCanCancelProducts(false);
            },
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FittedBox(
              child: Text(
                "Produtos solicitados",
                style: TextStyle(fontSize: 20),
              ),
            ),
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
                    expansibleGroupsPresenter: expansibleGroupsPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    saleRequestTempPresenter: saleRequestTempPresenter,
                    homePresenter: homePresenter,
                    loadCommandData: () async {
                      await printedProductsPresenter.loadCommandData(
                        commandNumber: homePresenter.commandNumber!,
                        printedProductsPresenter: printedProductsPresenter,
                        saleRequestTempPresenter: saleRequestTempPresenter,
                        expansibleGroupsPresenter: expansibleGroupsPresenter,
                        homePresenter: homePresenter,
                        clearPermissionToCancelProducts: true,
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
