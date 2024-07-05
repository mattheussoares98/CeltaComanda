import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
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

  Future<void> _loadGroupsAndProducts(MenuPresenter menuPresenter) async {
    await menuPresenter.getGroupsAndProducts("001");
  }

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
          await _loadGroupsAndProducts(menuPresenter);
          await cartPresenter.getLocalCartProductsData();
          await cartPresenter.getLocalConfirmedsCombox();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, menuPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, menuPresenter.mainErrorStream);

    return Scaffold(
      key: scaffoldKey,
      drawer: drawer(
        context: context,
        menuPresenter: menuPresenter,
        printedProductsPresenter: printedProductsPresenter,
        cartPresenter: cartPresenter,
        homePresenter: homePresenter,
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          backgroundColor: const Color(0xFFF1F5F8),
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
      ),
      body: StreamBuilder<
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
                    _loadGroupsAndProducts(menuPresenter);
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
                        AppBar().preferredSize.height -
                        kBottomNavigationBarHeight,
                    child: StreamBuilder<ProductsViewModel?>(
                        stream: menuPresenter.selectedProductStream,
                        builder: (context, selectedProduct) {
                          return Column(
                            children: [
                              GroupsAndProducts(
                                selectedIndex: selectedGroupIndex.data,
                                selectedProduct: selectedProduct.data,
                              ),
                              InsertProductButton(
                                selectedProduct: selectedProduct.data,
                                popScreen: false,
                              ),
                            ],
                          );
                        }),
                  );
                });
          }
        },
      ),
    );
  }
}
