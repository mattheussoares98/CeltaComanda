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
    with LoadingManager, UIErrorManager, SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController? _animationController;
  Animation<double>? _animation;

  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(
        milliseconds:
            AnimationManager.animateProductGoingMenuToCartDurationMilliseconds,
      ),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!);
  }

  bool _isAnimatig = false;
  void doAnimation() {
    if (!_isAnimatig) {
      _isAnimatig = true;
      _animationController?.reset();
      _animationController?.forward();

      Future.delayed(
          Duration(
            milliseconds: AnimationManager
                .animateProductGoingMenuToCartDurationMilliseconds,
          ), () {
        _isAnimatig = false;
      });
    }
  }

  @override
  void dispose() {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    _pageController.dispose();
    _animationController?.dispose();
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

        await commentsPresenter.loadComments();
        await homePresenter.getLocalCommandData();

        if (homePresenter.isFixedCommandNumber) {
          await loadCommandData(
            printedProductsPresenter: printedProductsPresenter,
            cartPresenter: cartPresenter,
            menuPresenter: menuPresenter,
            homePresenter: homePresenter,
          );
        } else {
          await menuPresenter.getGroupsAndProducts("001");
        }

        setState(() {});
      });
    }
  }

  Future<void> loadCommandData({
    required PrintedProductsPresenter printedProductsPresenter,
    required CartPresenter cartPresenter,
    required MenuPresenter menuPresenter,
    required HomePresenter homePresenter,
  }) async {
    await printedProductsPresenter.loadCommandData(
      cartPresenter: cartPresenter,
      menuPresenter: menuPresenter,
      homePresenter: homePresenter,
      clearPermissionToCancelProducts: true,
      isRemovingProduct: false,
    );
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
      makePrintedProductsPage(homePresenter.isFixedCommandNumber),
      if (true) makePaymentPage(),
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
        body: Stack(
          children: [
            SizedBox(
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
          ],
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
            StreamBuilder<bool>(
                stream: cartPresenter.animateProductGoingMenuToCartStream,
                builder: (context, snapshot) {
                  if (snapshot.data != true) {
                    return const SizedBox();
                  } else {
                    return AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        doAnimation();

                        return Positioned(
                          bottom: kBottomNavigationBarHeight / 2 + 10,
                          left: (MediaQuery.of(context).size.width / 6) +
                              (_animation!.value *
                                  ((MediaQuery.of(context).size.width / 6) *
                                      2)) -
                              5,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: kBottomNavigationBarHeight / 2 - 5,
                            width: kBottomNavigationBarHeight / 2 - 5,
                            child: Image.asset(
                              "lib/ui/assets/images/product_animation.png",
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
