import 'dart:async';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../presentation/presenters/presenters.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/pages.dart';
import '../../components/components.dart';

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

  void onPageChanged(int index) {
    setState(() {
      _pageController.jumpToPage(index);
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ExpansibleGroupsPage(),
      const PrintedProductsPage(),
      const SaleRequestTempPage(),
    ];

    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context);
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context);
    GetxHomePresenter homePresenter = Provider.of(context);

    return Builder(builder: (context) {
      loadingSubscription =
          handleLoading(context, homePresenter.isLoadingStream);
      mainErrorSubscription =
          handleMainError(context, homePresenter.mainErrorStream);

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
          actions: const [SearchCommandIcon()],
          title: AppBarTitle(
            currentIndex: _currentIndex,
            commandNumber: homePresenter.commandNumber,
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onPageChanged,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Inserir',
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
              label: 'Impressos',
            ),
            BottomNavigationBarItem(
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
          ],
        ),
      );
    });
  }
}
