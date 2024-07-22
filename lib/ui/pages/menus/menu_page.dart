import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class MenuPage extends StatefulWidget {
  final bool? isFixedCommandNumber;
  const MenuPage(
    this.isFixedCommandNumber, {
    super.key,
  });

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

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    if (!_isLoaded && menuPresenter.loadedMenu.isEmpty) {
      _isLoaded = true;
      Future.delayed(
        Duration.zero,
        () async {
          await cartPresenter.getLocalCartProductsData();
          await cartPresenter.getLocalConfirmedsCombox();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    // loadingSubscription = handleLoading(context, menuPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, menuPresenter.mainErrorStream);

    return Scaffold(
      body: StreamBuilder<bool>(
          stream: menuPresenter.showPreLoadImagesStream,
          builder: (context, showPreLoadImageSnapshot) {
            return StreamBuilder<
                List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>(
              stream: menuPresenter.menuStream,
              builder: (context, snapshot) {
                if (menuPresenter.loadedMenu.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: Center(
                      child: TextButton.icon(
                        key: const Key("loadMenu"),
                        onPressed: () async {
                          if (homePresenter.isFixedCommandNumber) {
                            await homePresenter.loadCommandData(
                              menuPresenter: menuPresenter,
                              printedProductsPresenter:
                                  printedProductsPresenter,
                              cartPresenter: cartPresenter,
                              commentsPresenter: commentsPresenter,
                            );
                          } else {
                            await menuPresenter.getGroupsAndProducts(
                              commandNumber: "001",
                              commentsPresenter: commentsPresenter,
                            );
                          }
                        },
                        icon: Icon(
                          Icons.menu_book,
                          size: hasMinWidth(context) ? 50 : 30,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        label: Text(
                          "Carregar menu",
                          style: TextStyle(
                            fontSize: hasMinWidth(context) ? 40 : 30,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return StreamBuilder<int>(
                      stream: menuPresenter.indexOfSelectedGroupStream,
                      builder: (context, selectedGroupIndex) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height -
                              kBottomNavigationBarHeight,
                          child: StreamBuilder<ProductsViewModel?>(
                              stream: menuPresenter.selectedProductStream,
                              builder: (context, selectedProduct) {
                                return Column(
                                  children: [
                                    if (showPreLoadImageSnapshot.data == true)
                                      const PreLoadImagesPage(),
                                    GroupsAndProducts(
                                      selectedIndex: selectedGroupIndex.data,
                                      selectedProduct: selectedProduct.data,
                                    ),
                                    InsertProductButton(
                                      selectedProduct: selectedProduct.data,
                                    ),
                                  ],
                                );
                              }),
                        );
                      });
                }
              },
            );
          }),
    );
  }
}
