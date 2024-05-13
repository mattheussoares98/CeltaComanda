import 'dart:async';

import 'package:provider/provider.dart';

import '../../../main/builders/builders.dart';
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
  static bool isDialogShowing = false;

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
    ExpansibleGroupsPresenter expansibleGroupsPresenter = Provider.of(context);
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    HomePresenter homePresenter = Provider.of(context);

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
            loadCommandData: () async {},
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
                  loadingSubscription = handleLoading(
                      context, saleRequestTempPresenter.isLoadingStream);
                  mainErrorSubscription = handleMainError(
                      context, saleRequestTempPresenter.mainErrorStream);

                  homeLoadingSubscription =
                      homePresenter.isLoadingStream.listen((isLoading) async {
                    if (isLoading == true && !isDialogShowing) {
                      isDialogShowing = true;
                      showLoading(
                        NavigatorKey.navigatorKey.currentState?.context ??
                            context,
                      );
                    } else {
                      hideLoading(
                        NavigatorKey.navigatorKey.currentState?.context ??
                            context,
                      );
                      isDialogShowing = false;
                    }
                  });

                  if (saleRequestTempPresenter
                          .saleRequestTemp?.Products.isNotEmpty ==
                      true) {
                    return SaleRequestProductsItems(
                        saleRequestTempViewModel:
                            saleRequestTempPresenter.saleRequestTemp!);
                  }
                  return SearchDataByCommandNumber(
                    expansibleGroupsPresenter: expansibleGroupsPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    saleRequestTempPresenter: saleRequestTempPresenter,
                    homePresenter: homePresenter,
                    loadCommandData: () async {
                      await saleRequestTempPresenter.loadSaleRequest(
                        homePresenter.commandNumber!,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          if (saleRequestTempPresenter.saleRequestTemp?.Products.isNotEmpty ==
              true)
            const SaveSaleRequestButton(),
        ],
      ),
    );
  }
}
