import 'dart:async';

import 'package:clean_celta_mobile/ui/components/components.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

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
  }) {
    setState(() {
      _pageController.jumpToPage(index);
      _currentIndex = index;
    });
    printedProductsPresenter.updateCanCancelProducts(false);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ExpansibleGroupsPage(),
      const SaleRequestTempPage(),
      const PrintedProductsPage(),
    ];

    SaleRequestTempPresenter saleRequestTempPresenter = Provider.of(context);
    PrintedProductsPresenter printedProductsPresenter = Provider.of(context);

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
                printedProductsPresenter: printedProductsPresenter);
          },
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            onPageChanged(
                index: index,
                printedProductsPresenter: printedProductsPresenter);
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Inserir',
            ),
            BottomNavigationBarItem(
              key: const Key("BottomNavigationExpansibleGroups"),
              icon: IconWithNumberQuantity(
                iconData: Icons.shopping_cart_outlined,
                productsQuantity: saleRequestTempPresenter.saleRequestTemp ==
                            null ||
                        saleRequestTempPresenter
                                .saleRequestTemp?.Products.isEmpty ==
                            true
                    ? 0
                    : saleRequestTempPresenter.saleRequestTemp!.Products.length,
              ),
              label: 'Pendentes',
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
          ],
        ),
      ),
    );
  }
}
