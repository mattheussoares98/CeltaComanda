import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main/builders/builders.dart';
import '../../../main/factories/factories.dart';
import '../../../ui/components/components.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    super.dispose();
  }

  bool _isLoaded = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      Future.delayed(Duration.zero, () async {
        HomePresenter homePresenter = Provider.of(context, listen: false);
        PrintedProductsPresenter printedProductsPresenter =
            Provider.of(context, listen: false);
        CartPresenter cartPresenter = Provider.of(context, listen: false);
        MenuPresenter menuPresenter = Provider.of(context, listen: false);
        CommentsPresenter commentsPresenter =
            Provider.of(context, listen: false);

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            await homePresenter.getLocalCommandData();
            await homePresenter.loadCommandData(
              menuPresenter: menuPresenter,
              printedProductsPresenter: printedProductsPresenter,
              cartPresenter: cartPresenter,
              commentsPresenter: commentsPresenter,
              homePresenter: homePresenter,
            );
            // setState(() {});
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(
        context); //precisa deixar com o listen == true pra atualizar a quantidade corretamente no BottomNavigationBarItem
    PrintedProductsPresenter printedProductsPresenter = Provider.of(
        context); //precisa deixar com o listen == true pra atualizar a quantidade corretamente no BottomNavigationBarItem
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription = handleLoading(context, homePresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, homePresenter.mainErrorStream);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        UserInteraction.restartTimes();
      },
      onPanDown: (_) {
        UserInteraction.restartTimes();
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
          drawer: drawer(
            context: context,
            menuPresenter: menuPresenter,
            printedProductsPresenter: printedProductsPresenter,
            cartPresenter: cartPresenter,
            homePresenter: homePresenter,
          ),
          appBar: homeAppBar(
            printedProductsPresenter: printedProductsPresenter,
            homePresenter: homePresenter,
            context: context,
            cartPresenter: cartPresenter,
            menuPresenter: menuPresenter,
          ),
          body: makeMenusPage(homePresenter.isFixedCommandNumber),
        ),
      ),
    );
  }
}
