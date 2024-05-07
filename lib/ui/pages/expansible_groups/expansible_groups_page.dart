import 'package:provider/provider.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/pages.dart';

import 'package:flutter/material.dart';

class ExpansibleGroupsPage extends StatefulWidget {
  final ProductsPresenter productsPresenter;
  const ExpansibleGroupsPage(this.productsPresenter, {super.key});

  @override
  State<ExpansibleGroupsPage> createState() => _ExpansibleGroupsPageState();
}

class _ExpansibleGroupsPageState extends State<ExpansibleGroupsPage>
    with LoadingManager, UIErrorManager {
  @override
  Widget build(BuildContext context) {
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context);
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);
    GetxHomePresenter homePresenter = Provider.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  handleLoading(
                      context, expansibleGroupsPresenter.isLoadingStream);
                  handleLoading(
                      context, widget.productsPresenter.isLoadingStream);
                  handleMainError(
                      context, expansibleGroupsPresenter.mainErrorStream);

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
                          productsPresenter: widget.productsPresenter,
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
