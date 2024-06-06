import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/usecases/usecases.dart';
import '../../../presentation/presenters/presenters.dart';
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
  }) {
    setState(() {
      _pageController.jumpToPage(index);
      _currentIndex = index;
    });
    printedProductsPresenter.updateCanCancelProducts(false);
    homePresenter.onChangePage(menuPresenter: menuPresenter);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const MenuPage(),
      const CartPage(),
      const PrintedProductsPage(),
      PaymentPage(GetxPaymentPresenter(
        pay: RedePay(),
      )),
    ];

    CartPresenter cartPresenter = Provider.of(context);
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            onPageChanged(
              index: index,
              printedProductsPresenter: printedProductsPresenter,
              menuPresenter: menuPresenter,
              homePresenter: homePresenter,
            );
          },
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          selectedIconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.primary),
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) {
            onPageChanged(
              index: index,
              printedProductsPresenter: printedProductsPresenter,
              menuPresenter: menuPresenter,
              homePresenter: homePresenter,
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
                iconColor: _currentIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                iconData: Icons.shopping_cart_outlined,
                productsQuantity: cartPresenter.cartProducts.length,
              ),
              label: 'Carrinho',
            ),
            BottomNavigationBarItem(
              icon: IconWithNumberQuantity(
                iconColor: _currentIndex == 2
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
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
