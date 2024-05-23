import 'package:clean_celta_mobile/ui/helpers/convert/convert.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
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

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  int indexOfSelectedProductCommentIcon = -1;
  final commentTextController = TextEditingController();

  Future<void> _updateSaleRequest({
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    try {
      await expansibleGroupsPresenter.updateSaleRequest(
          homePresenter: homePresenter,
          saleRequestTempPresenter: saleRequestTempPresenter,
          products: [
            UpdateSaleRequestTempProductEntity(
              ProductInternalCodeOnErp: expansibleGroupsPresenter
                  .searchedProduct!.InternalCodeOnERP
                  .toString()
                  .toInt(),
              ProductPriceLookUpCode:
                  expansibleGroupsPresenter.searchedProduct!.PriceLookupCode,
              Quantity:
                  expansibleGroupsPresenter.searchedProduct!.productQuantity,
              SaleRequestTempId: int.parse(
                  saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId),
              TotalLiquid: expansibleGroupsPresenter
                      .searchedProduct!.SaleRetailPraticed
                      .toDouble() *
                  expansibleGroupsPresenter.searchedProduct!.productQuantity,
              Value: expansibleGroupsPresenter
                  .searchedProduct!.SaleRetailPraticed
                  .toDouble(),
              Comments: commentTextController.text.isEmpty == true
                  ? null
                  : commentTextController.text,
            ),
          ]);
      _hideFormField();
    } catch (e) {
      e;
    }
  }

  void _addProductQuantity(
      ExpansibleGroupsPresenter expansibleGroupsPresenter) {
    setState(() {
      expansibleGroupsPresenter.searchedProduct!.productQuantity++;
    });
  }

  void _subtractProductQuantity(
      ExpansibleGroupsPresenter expansibleGroupsPresenter) {
    setState(() {
      expansibleGroupsPresenter.searchedProduct!.productQuantity--;
    });
  }

  void _clearProductQuantity(
      ExpansibleGroupsPresenter expansibleGroupsPresenter) {
    setState(() {
      expansibleGroupsPresenter.searchedProduct!.productQuantity = 1;
    });
  }

  void _hideFormField() {
    setState(() {
      indexOfSelectedProductCommentIcon = -1;
    });
  }

  void _updateSelectedIndex() {
    if (indexOfSelectedProductCommentIcon == 0) {
      setState(() {
        indexOfSelectedProductCommentIcon = -1;
      });
    } else {
      setState(() {
        indexOfSelectedProductCommentIcon = 0;
      });
    }
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
                        ProductItemWidget(
                          addProductQuantity: () {
                            _addProductQuantity(expansibleGroupsPresenter);
                          },
                          clearProductQuantity: () {
                            _clearProductQuantity(expansibleGroupsPresenter);
                          },
                          subtractProductQuantity: () {
                            _subtractProductQuantity(expansibleGroupsPresenter);
                          },
                          updateSaleRequest: () async {
                            await _updateSaleRequest(
                              expansibleGroupsPresenter:
                                  expansibleGroupsPresenter,
                              homePresenter: homePresenter,
                              saleRequestTempPresenter:
                                  saleRequestTempPresenter,
                            );
                          },
                          productQuantity: expansibleGroupsPresenter
                              .searchedProduct!.productQuantity,
                          index: 0,
                          selectedIndex: indexOfSelectedProductCommentIcon,
                          updateSelectedIndex: _updateSelectedIndex,
                          goToComboxPage: () {
                            expansibleGroupsPresenter.goToComboxPage(
                              expansibleGroupsPresenter.searchedProduct!,
                            );
                          },
                          productsViewModel:
                              expansibleGroupsPresenter.searchedProduct!,
                          commentTextController: commentTextController,
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
