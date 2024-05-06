import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../main/factories/factories.dart';
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
  final List<Widget> _screens = [
    const ExpansibleGroupsPage(),
    const PrintedProductsPage(),
    const SaleRequestTempPage(),
  ];

  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _pageController.jumpToPage(index);
      _currentIndex = index;
    });
  }

  final homePresenter = GetxHomePresenter(
    loadExpansibleGroups: makeRemoteLoadExpansibleGroups(),
    localEnterpriseData: makeLocalEnterpriseData(),
    navigateTo: makeNavigateTo(),
    ticketIsPermitted: makeRemoteticketIsPermitted(),
  );

  @override
  Widget build(BuildContext context) {
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: true);
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: true);
    GetxPrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: true);
    GetxHomePresenter homePresenter =
        Provider.of(context, listen: true);

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
      body: Builder(builder: (context) {
        handleLoading(context, homePresenter.isLoadingStream);
        handleMainError(context, homePresenter.mainErrorStream);
    
        return PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: _screens,
        );
      }),
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
  }
}
