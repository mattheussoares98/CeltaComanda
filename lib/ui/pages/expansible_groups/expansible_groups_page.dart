import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/pages.dart';
import '../../components/components.dart';

class ExpansibleGroupsPage extends StatefulWidget {
  const ExpansibleGroupsPage({super.key});

  @override
  State<ExpansibleGroupsPage> createState() => _ExpansibleGroupsPageState();
}

class _ExpansibleGroupsPageState extends State<ExpansibleGroupsPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  TextEditingController productCommentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupsPresenter expansibleGroupsPresenter = Provider.of(context);
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
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
          SearchCommandIcon(loadCommandData: () async {
            await expansibleGroupsPresenter.loadCommandData(
              commandNumber: homePresenter.commandNumber!,
              printedProductsPresenter: printedProductsPresenter,
              saleRequestTempPresenter: saleRequestTempPresenter,
              expansibleGroupsPresenter: expansibleGroupsPresenter,
              homePresenter: homePresenter,
            );
          })
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FittedBox(
              child: Text(
                "Produtos",
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
                      context, expansibleGroupsPresenter.isLoadingStream);
                  mainErrorSubscription = handleMainError(
                      context, expansibleGroupsPresenter.mainErrorStream);

                  if (expansibleGroupsPresenter.expansibleGroups.isEmpty) {
                    return SearchDataByCommandNumber(
                      expansibleGroupsPresenter: expansibleGroupsPresenter,
                      printedProductsPresenter: printedProductsPresenter,
                      saleRequestTempPresenter: saleRequestTempPresenter,
                      homePresenter: homePresenter,
                      loadCommandData: () async {
                        await expansibleGroupsPresenter.loadCommandData(
                          commandNumber: homePresenter.commandNumber!,
                          printedProductsPresenter: printedProductsPresenter,
                          saleRequestTempPresenter: saleRequestTempPresenter,
                          expansibleGroupsPresenter: expansibleGroupsPresenter,
                          homePresenter: homePresenter,
                        );
                      },
                    );
                  }

                  return Column(
                    children: [
                      const SearchProduct(),
                      if (expansibleGroupsPresenter.searchedProduct != null)
                        ProductItem(
                          productCommentController: productCommentController,
                          goToComboxPage: () {
                            expansibleGroupsPresenter.goToComboxPage(
                              expansibleGroupsPresenter.searchedProduct!,
                            );
                          },
                          product: expansibleGroupsPresenter.searchedProduct!,
                          updateProductQuantity: () async {
                            await expansibleGroupsPresenter.updateSaleRequest(
                              productsViewModel:
                                  expansibleGroupsPresenter.searchedProduct!,
                              homePresenter: homePresenter,
                              saleRequestTempPresenter:
                                  saleRequestTempPresenter,
                              productComment: "teste",
                            );
                          },
                        ),
                      GroupItems(
                        expansibleGroupsViewModel:
                            expansibleGroupsPresenter.expansibleGroups,
                      ),
                    ],
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
