import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';
import '../pages.dart';
import '../../components/components.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
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

  Future<void> _addProductInCart({
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) async {
    try {
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
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    if (!_isLoaded && menuPresenter.loadedMenu.isEmpty) {
      _isLoaded = true;
      Future.delayed(Duration.zero, () async {
        await _loadGroupsAndProducts(menuPresenter);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
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
        title: const FittedBox(
          child: Text(
            "Menu",
            style: TextStyle(fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _loadGroupsAndProducts(menuPresenter);
            },
            icon: Icon(
              Icons.refresh_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: "Atualizar menu",
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          loadingSubscription?.cancel();
          mainErrorSubscription?.cancel();

          loadingSubscription =
              handleLoading(context, menuPresenter.isLoadingStream);
          mainErrorSubscription =
              handleMainError(context, menuPresenter.mainErrorStream);

          return StreamBuilder<
              List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>(
            stream: menuPresenter.menuStream,
            builder: (context, snapshot) {
              if (menuPresenter.loadedMenu.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height,
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        _loadGroupsAndProducts(menuPresenter);
                      },
                      child: const Text("Carregar menu"),
                    ),
                  ),
                );
              } else {
                return StreamBuilder<int>(
                    stream: menuPresenter.indexOfSelectedGroupStream,
                    builder: (context, snapshot) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            kBottomNavigationBarHeight -
                            50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GroupItems(
                                  expansibleGroupsViewModel: menuPresenter
                                      .loadedMenu
                                      .map((element) => element.keys.first)
                                      .toList(),
                                  selectedIndex: snapshot.data ?? 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 80,
                              child: ProductsItems(
                                itensPerLine: 2,
                                products: menuPresenter
                                    .loadedMenu[snapshot.data ?? 0]
                                    .entries
                                    .first
                                    .value,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                // const SearchProduct(),
                // if (menuPresenter.searchedProduct != null)
                //   ProductItemWidget(
                //     addProductQuantity: () {
                //       _addProductQuantity(menuPresenter);
                //     },
                //     clearProductQuantity: () {
                //       _clearProductQuantity(menuPresenter);
                //     },
                //     subtractProductQuantity: () {
                //       _subtractProductQuantity(menuPresenter);
                //     },
                //     updateSaleRequest: () async {
                //       await _addProductInCart(
                //         menuPresenter: menuPresenter,
                //         homePresenter: homePresenter,
                //         saleRequestTempPresenter:
                //             saleRequestTempPresenter,
                //       );
                //     },
                //     productQuantity: menuPresenter
                //         .searchedProduct!.productQuantity,
                //     index: 0,
                //     selectedIndex:
                //         indexOfSelectedProductCommentIcon,
                //     updateSelectedIndex: _updateSelectedIndex,
                //     goToComboxPage: () {
                //       menuPresenter.goToComboxPage(
                //         menuPresenter.searchedProduct!,
                //       );
                //     },
                //     productsViewModel:
                //         menuPresenter.searchedProduct!,
                //     commentTextController: commentTextController,
                //   ),
              }
            },
          );
        },
      ),
    );
  }
}
