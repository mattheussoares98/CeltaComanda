import 'dart:async';

import 'package:provider/provider.dart';

import '../../../main/builders/builders.dart';
import '../../../presentation/presenters/presenters.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/pages.dart';

import 'package:flutter/material.dart';

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
  StreamSubscription? homeLoadingSubscription;
  static bool isDialogShowing = false;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context);
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);
    GetxHomePresenter homePresenter = Provider.of(context);
    GetxProductsPresenter productsPresenter = Provider.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  loadingSubscription = handleLoading(
                      context, expansibleGroupsPresenter.isLoadingStream);
                  mainErrorSubscription = handleMainError(
                      context, expansibleGroupsPresenter.mainErrorStream);

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

                  if (expansibleGroupsPresenter.expansibleGroups.isEmpty) {
                    return SearchDataByCommandNumber(
                      expansibleGroupsPresenter: expansibleGroupsPresenter,
                      printedProductsPresenter: printedProductsPresenter,
                      saleRequestTempPresenter: saleRequestTempPresenter,
                      homePresenter: homePresenter,
                    );
                  }

                  return Column(
                    children: [
                      const SearchProduct(),
                      if (expansibleGroupsPresenter.searchedProduct != null)
                        ProductItem(
                          product: expansibleGroupsPresenter.searchedProduct!,
                          productsPresenter: productsPresenter,
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
