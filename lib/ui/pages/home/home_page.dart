import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main/factories/factories.dart';
import '../../../ui/components/components.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/pages.dart';
import 'components/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with LoadingManager, UIErrorManager {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  @override
  void dispose() {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged({
    required int index,
    required PrintedProductsPresenter printedProductsPresenter,
    required HomePresenter homePresenter,
    required MenuPresenter menuPresenter,
    required CommentsPresenter commentsPresenter,
  }) {
    setState(() {
      _pageController.jumpToPage(index);
      _currentIndex = index;
    });
    homePresenter.onChangePage(
      menuPresenter: menuPresenter,
      commentsPresenter: commentsPresenter,
      printedProductsPresenter: printedProductsPresenter,
    );
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      Future.delayed(Duration.zero, () async {
        CommentsPresenter commentsPresenter =
            Provider.of(context, listen: false);
        HomePresenter homePresenter = Provider.of(context, listen: false);

        await commentsPresenter.loadComments();
        await homePresenter.getLocalCommandData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context);
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    final List<Widget> screens = [
      makeMenusPage(homePresenter.isFixedCommandNumber),
      makeCartPage(_pageController, homePresenter.isFixedCommandNumber),
      makePrintedProductsPage(),
      if (cartPresenter.isGeneratingVersionToRede) makePaymentPage(),
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        notificationDialog(
          context: context,
          titleMessage: "Fechar aplicativo",
          content: const Text("Deseja realmente fechar o aplicativo?"),
          onPress: () async {
            SystemNavigator.pop();
          },
        );
      },
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              onPageChanged(
                index: index,
                printedProductsPresenter: printedProductsPresenter,
                menuPresenter: menuPresenter,
                homePresenter: homePresenter,
                commentsPresenter: commentsPresenter,
              );
            },
            children: screens,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Theme.of(context).primaryColorLight,
          selectedItemColor: Theme.of(context).primaryColorDark,
          // selectedIconTheme:
          //     IconThemeData(color: Theme.of(context).secondaryHeaderColor),
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) {
            onPageChanged(
              index: index,
              printedProductsPresenter: printedProductsPresenter,
              menuPresenter: menuPresenter,
              homePresenter: homePresenter,
              commentsPresenter: commentsPresenter,
            );
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.menu_book_rounded,
              ),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              key: const Key("BottomNavigationExpansibleGroups"),
              icon: IconWithNumberQuantity(
                iconData: Icons.shopping_cart,
                productsQuantity: cartPresenter.cartProducts.length +
                    cartPresenter.confirmedCombox.length,
              ),
              label: 'Carrinho',
            ),
            BottomNavigationBarItem(
              icon: IconWithNumberQuantity(
                iconData: Icons.list_outlined,
                productsQuantity: printedProductsPresenter.printedProducts ==
                            null ||
                        printedProductsPresenter
                                .printedProducts?.Products.isEmpty ==
                            true
                    ? 0
                    : printedProductsPresenter.printedProducts!.Products.length,
              ),
              label: 'Solicitados',
            ),
            if (cartPresenter.isGeneratingVersionToRede)
              const BottomNavigationBarItem(
                icon: Icon(Icons.paypal),
                label: 'Pagar',
              ),
          ],
        ),
      ),
    );
  }
}
