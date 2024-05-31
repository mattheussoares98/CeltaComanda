import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/convert/convert.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
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
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    try {
      await menuPresenter.updateSaleRequest(
          homePresenter: homePresenter,
          saleRequestTempPresenter: saleRequestTempPresenter,
          products: [
            UpdateSaleRequestTempProductEntity(
              ProductInternalCodeOnErp: menuPresenter
                  .searchedProduct!.InternalCodeOnERP
                  .toString()
                  .toInt(),
              ProductPriceLookUpCode:
                  menuPresenter.searchedProduct!.PriceLookupCode,
              Quantity: menuPresenter.searchedProduct!.productQuantity,
              SaleRequestTempId: int.parse(
                  saleRequestTempPresenter.saleRequestTemp!.SaleRequestTempId),
              TotalLiquid:
                  menuPresenter.searchedProduct!.SaleRetailPraticed.toDouble() *
                      menuPresenter.searchedProduct!.productQuantity,
              Value:
                  menuPresenter.searchedProduct!.SaleRetailPraticed.toDouble(),
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

  void _addProductQuantity(MenuPresenter menuPresenter) {
    setState(() {
      menuPresenter.searchedProduct!.productQuantity++;
    });
  }

  void _subtractProductQuantity(MenuPresenter menuPresenter) {
    setState(() {
      menuPresenter.searchedProduct!.productQuantity--;
    });
  }

  void _clearProductQuantity(MenuPresenter menuPresenter) {
    setState(() {
      menuPresenter.searchedProduct!.productQuantity = 1;
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

  Future<void> _loadGroupsAndProducts(MenuPresenter menuPresenter) async {
    await menuPresenter.getGroupsAndProducts("001");
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_isLoaded) {
      _isLoaded = true;
      MenuPresenter menuPresenter = Provider.of(context, listen: false);
      await _loadGroupsAndProducts(menuPresenter);
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);
    SaleRequestTempPresenter saleRequestTempPresenter =
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
          SearchCommandIcon(loadCommandData: () async {
            await menuPresenter.loadCommandData(
              commandNumber: homePresenter.commandNumber!,
              printedProductsPresenter: printedProductsPresenter,
              saleRequestTempPresenter: saleRequestTempPresenter,
              menuPresenter: menuPresenter,
              homePresenter: homePresenter,
            );
          })
        ],
        title: const FittedBox(
          child: Text(
            "Menu",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  loadingSubscription?.cancel();
                  mainErrorSubscription?.cancel();

                  loadingSubscription =
                      handleLoading(context, menuPresenter.isLoadingStream);
                  mainErrorSubscription =
                      handleMainError(context, menuPresenter.mainErrorStream);

                  if (menuPresenter.menus.isEmpty) {
                    return SearchDataByCommandNumber(
                      menuPresenter: menuPresenter,
                      printedProductsPresenter: printedProductsPresenter,
                      saleRequestTempPresenter: saleRequestTempPresenter,
                      homePresenter: homePresenter,
                      emptyMessage:
                          "Consulte alguma comanda para conseguir visualizar os produtos/combos e adicionar na comanda",
                      loadCommandData: () async {
                        await menuPresenter.loadCommandData(
                          commandNumber: homePresenter.commandNumber!,
                          printedProductsPresenter: printedProductsPresenter,
                          saleRequestTempPresenter: saleRequestTempPresenter,
                          menuPresenter: menuPresenter,
                          homePresenter: homePresenter,
                        );
                      },
                    );
                  }

                  return Column(
                    children: [
                      const SearchProduct(),
                      if (menuPresenter.searchedProduct != null)
                        ProductItemWidget(
                          addProductQuantity: () {
                            _addProductQuantity(menuPresenter);
                          },
                          clearProductQuantity: () {
                            _clearProductQuantity(menuPresenter);
                          },
                          subtractProductQuantity: () {
                            _subtractProductQuantity(menuPresenter);
                          },
                          updateSaleRequest: () async {
                            await _updateSaleRequest(
                              menuPresenter: menuPresenter,
                              homePresenter: homePresenter,
                              saleRequestTempPresenter:
                                  saleRequestTempPresenter,
                            );
                          },
                          productQuantity:
                              menuPresenter.searchedProduct!.productQuantity,
                          index: 0,
                          selectedIndex: indexOfSelectedProductCommentIcon,
                          updateSelectedIndex: _updateSelectedIndex,
                          goToComboxPage: () {
                            menuPresenter.goToComboxPage(
                              menuPresenter.searchedProduct!,
                            );
                          },
                          productsViewModel: menuPresenter.searchedProduct!,
                          commentTextController: commentTextController,
                        ),
                      StreamBuilder<int>(
                          stream: menuPresenter.indexOfSelectedGroupStream,
                          builder: (context, snapshot) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 27,
                                  child: GroupItems(
                                    expansibleGroupsViewModel: menuPresenter
                                        .menus
                                        .map((element) => element.keys.first)
                                        .toList(),
                                    selectedIndex: snapshot.data ?? 0,
                                  ),
                                ),
                                Expanded(
                                  flex: 73,
                                  child: ProductsItems(
                                    products: menuPresenter
                                        .menus[snapshot.data ?? 0]
                                        .entries
                                        .first
                                        .value,
                                  ),
                                ),
                              ],
                            );
                          }),
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
