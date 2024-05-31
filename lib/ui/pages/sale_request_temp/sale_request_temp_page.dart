import 'dart:async';

import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class SaleRequestTempPage extends StatefulWidget {
  const SaleRequestTempPage({super.key});

  @override
  State<SaleRequestTempPage> createState() => _SaleRequestTempPageState();
}

class _SaleRequestTempPageState extends State<SaleRequestTempPage>
    with UIErrorManager, LoadingManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? homeLoadingSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    homeLoadingSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter = Provider.of(context);
    MenuPresenter menuPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Scaffold(
      drawer: drawer(
        context: context,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        saleRequestTempPresenter: saleRequestTempPresenter,
        homePresenter: homePresenter,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F8),
        actions: [
          SearchCommandIcon(
            loadCommandData: () async {
              await saleRequestTempPresenter.loadCommandData(
                commandNumber: homePresenter.commandNumber!,
                printedProductsPresenter: printedProductsPresenter,
                saleRequestTempPresenter: saleRequestTempPresenter,
                menuPresenter: menuPresenter,
                homePresenter: homePresenter,
              );
            },
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FittedBox(
              child: Text(
                "Pendentes para impressão",
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

                  loadingSubscription = handleLoading(
                      context, saleRequestTempPresenter.isLoadingStream);
                  mainErrorSubscription = handleMainError(
                      context, saleRequestTempPresenter.mainErrorStream);

                  if (saleRequestTempPresenter
                          .saleRequestTemp?.Products.isNotEmpty ==
                      true) {
                    return SaleRequestProductsItems(
                        saleRequestTempViewModel:
                            saleRequestTempPresenter.saleRequestTemp!);
                  }
                  return SearchDataByCommandNumber(
                    menuPresenter: menuPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    saleRequestTempPresenter: saleRequestTempPresenter,
                    homePresenter: homePresenter,
                    emptyMessage: homePresenter.commandNumber == null
                        ? "Consulte alguma comanda para visualizar os produtos que estão pendentes"
                        : "Não há produtos pendentes nessa comanda",
                    loadCommandData: () async {
                      await saleRequestTempPresenter.loadCommandData(
                        commandNumber: homePresenter.commandNumber!,
                        printedProductsPresenter: printedProductsPresenter,
                        saleRequestTempPresenter: saleRequestTempPresenter,
                        menuPresenter: menuPresenter,
                        homePresenter: homePresenter,
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
