import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main/builders/builders.dart';
import '../../../ui/components/components.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/pages/pages.dart';
import '../../helpers/helpers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  ProductsViewModel? _lastShowedSuggestionProduct;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  Future<void> _loadAllData() async {
    Future.delayed(Duration.zero, () async {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        HomePresenter homePresenter = Provider.of(context, listen: false);
        PrintedProductsPresenter printedProductsPresenter =
            Provider.of(context, listen: false);
        CartPresenter cartPresenter = Provider.of(context, listen: false);
        MenuPresenter menuPresenter = Provider.of(context, listen: false);
        ExpansibleGroupFromProductPresenter
            expansibleGroupFromProductPresenter =
            Provider.of(context, listen: false);

        if (mounted) {
          await homePresenter.loadCommandData(
            updateMenuCount: 0,
            menuPresenter: menuPresenter,
            printedProductsPresenter: printedProductsPresenter,
            cartPresenter: cartPresenter,
            expansibleGroupFromProductPresenter:
                expansibleGroupFromProductPresenter,
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(
        context); //precisa deixar com o listen == true pra atualizar a quantidade corretamente no AppBar
    PrintedProductsPresenter printedProductsPresenter = Provider.of(
        context); //precisa deixar com o listen == true pra atualizar a quantidade corretamente no AppBar
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
        onPopInvokedWithResult: (didPop, _) {
          if (!homePresenter.isGeneratingVersionToTablet) {
            notificationDialog(
              context: context,
              titleMessage: R.string.msgCloseApplication,
              content: Text(R.string.msgWantCloseApplication),
              onPress: () async {
                SystemNavigator.pop();
              },
            );
          }
        },
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
          //não abre o drawer se arrastar a tela da esquerda pra direita bem no cantinho
          drawer: homePresenter.isGeneratingVersionToRede ||
                  homePresenter.isGeneratingVersionToGetNet
              ? const DrawerItems()
              : null,
          appBar: homeAppBar(
            printedProductsPresenter: printedProductsPresenter,
            homePresenter: homePresenter,
            context: context,
            cartPresenter: cartPresenter,
            menuPresenter: menuPresenter,
          ),
          body: StreamBuilder<ProductsViewModel?>(
              stream: menuPresenter.atualSuggestionProductStream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != _lastShowedSuggestionProduct) {
                  _lastShowedSuggestionProduct = snapshot.data;
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    showSuggestionDialog(
                      context,
                      snapshot.data!,
                      menuPresenter,
                    );
                  });
                }
                return MenuPage(homePresenter.isFixedCommandNumber);
              }),
        ),
      ),
    );
  }
}
