import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main/builders/builders.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription? loadingSubscription;

  @override
  void dispose() {
    loadingSubscription?.cancel();
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
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
        PrintedProductsPresenter printedProductsPresenter =
            Provider.of(context, listen: false);
        CartPresenter cartPresenter = Provider.of(context, listen: false);
        MenuPresenter menuPresenter = Provider.of(context, listen: false);

        await homePresenter.getLocalCommandData();
        if (homePresenter.isFixedCommandNumber) {
          await printedProductsPresenter.loadCommandData(
            cartPresenter: cartPresenter,
            menuPresenter: menuPresenter,
            homePresenter: homePresenter,
            clearPermissionToCancelProducts: true,
            isRemovingProduct: false,
          );
        } else {
          await menuPresenter.getGroupsAndProducts("001");
        }
        await commentsPresenter.loadComments();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
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

    loadingSubscription = handleLoading(context, homePresenter.isLoadingStream);

    final List<Widget> screens = [
      makeMenusPage(homePresenter.isFixedCommandNumber),
      makeCartPage(_pageController, homePresenter.isFixedCommandNumber),
      makePrintedProductsPage(homePresenter.isFixedCommandNumber),
      if (homePresenter.isGeneratingVersionToRede) makePaymentPage(),
    ];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        UserInteraction.handleUserInteraction(_pageController);
      },
      onPanDown: (_) {
        UserInteraction.handleUserInteraction(_pageController);
      },
      child: PopScope(
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
          key: scaffoldKey,
          drawer: drawer(
            context: context,
            menuPresenter: menuPresenter,
            printedProductsPresenter: printedProductsPresenter,
            cartPresenter: cartPresenter,
            homePresenter: homePresenter,
          ),
          appBar: homeAppBar(
            homePresenter: homePresenter,
            cartPresenter: cartPresenter,
            menuPresenter: menuPresenter,
            printedProductsPresenter: printedProductsPresenter,
            context: context,
            scaffoldKey: scaffoldKey,
            currentIndex: _currentIndex,
          ),
          body: PageView(
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
          bottomNavigationBar: Stack(
            children: [
              HomeBottomNavigationBarItem(
                onPageChanged: (value) {
                  onPageChanged(
                    index: value,
                    printedProductsPresenter: printedProductsPresenter,
                    homePresenter: homePresenter,
                    menuPresenter: menuPresenter,
                    commentsPresenter: commentsPresenter,
                  );
                },
                currentIndex: _currentIndex,
              ),
              const ProductGoingToMenuAnimation(),
              const CartGoingToPrintedAnimation(),
            ],
          ),
        ),
      ),
    );
  }
}
