// import 'package:battery_plus/battery_plus.dart';
// ignore_for_file: use_build_context_synchronously

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
  Timer? loadPrintedTimer;
  Timer? needUpdateAppTimer;
  Timer? verifyNeedUpdateMenuOrImagesTimer;

  @override
  initState() {
    super.initState();
    startTimers();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Provider.of(context, listen: false);
        CartPresenter cartPresenter = Provider.of(context, listen: false);
        ConfigurationsPresenter configurationsPresenter =
            Provider.of(context, listen: false);
        PrintedProductsPresenter printedProductsPresenter =
            Provider.of(context, listen: false);
        MenuPresenter menuPresenter = Provider.of(context, listen: false);
        ExpansibleGroupFromProductPresenter
            expansibleGroupFromProductPresenter =
            Provider.of(context, listen: false);

        await homePresenter.loadCommandData(
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
        await homePresenter.updateWhatNeed(
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          configurationsPresenter: configurationsPresenter,
        );

        await homePresenter.updateDeviceInformations();

        await verifyNeedUpdateApp(homePresenter);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadPrintedTimer?.cancel();
    needUpdateAppTimer?.cancel();
    verifyNeedUpdateMenuOrImagesTimer?.cancel();
  }

  void startTimers() {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    loadPrintedTimer = Timer.periodic(Duration(minutes: 1), (_) async {
      if (homePresenter.commandEntity?.commandNumber != null) {
        await printedProductsPresenter.loadPrinted(
          homePresenter.commandEntity!.commandNumber!,
          showIsLoading: false,
        );
      }
    });

    needUpdateAppTimer = Timer.periodic(Duration(hours: 1), (_) async {
      await verifyNeedUpdateApp(homePresenter);
    });

    verifyNeedUpdateMenuOrImagesTimer = Timer.periodic(
        Duration(
          minutes: EnterpriseBuilder.entity?.minutesVerifyUpdateMenu ?? 5,
        ), (_) async {
      await homePresenter.updateWhatNeed(
        menuPresenter: menuPresenter,
        expansibleGroupFromProductPresenter:
            expansibleGroupFromProductPresenter,
        configurationsPresenter: configurationsPresenter,
      );
      setState(() {});
    });
  }

  Future<void> verifyNeedUpdateApp(HomePresenter homePresenter) async {
    bool isLatestVersion = await homePresenter.applicationIsInLatestVersion();
    if (!isLatestVersion) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      notificationDialog(
        context: context,
        titleMessage: R.string.msgNeedUpdateApplication,
        content: null,
        showCancelAndConfirmMessage: false,
        showCloseAction: true,
        onPress: () async {},
        canPop: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(
        context); //precisa deixar com o listen == true pra atualizar a quantidade corretamente no AppBar
    PrintedProductsPresenter printedProductsPresenter = Provider.of(
        context); //precisa deixar com o listen == true pra atualizar a quantidade corretamente no AppBar
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    EnterprisePresenter enterprisePresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    loadingSubscription = handleLoading(context, homePresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, homePresenter.mainErrorStream);

    return ListenFirebaseStreamAndCallFunction(
      collection: "clients",
      doc: EnterpriseBuilder.entity!.enterpriseName,
      function: (data) async {
        await homePresenter.doOnRemoteEnterpriseChanges(
          data: data,
          menuPresenter: menuPresenter,
          printedProductsPresenter: printedProductsPresenter,
          cartPresenter: cartPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          enterprisePresenter: enterprisePresenter,
        );
      },
      child: GestureDetector(
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
            loadingSubscription?.cancel();
            mainErrorSubscription?.cancel();
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
            drawer: homePresenter.commandEntity?.isFixedCommandNumber != true
                ? const DrawerItems()
                : null,
            appBar: homeAppBar(
              printedProductsPresenter: printedProductsPresenter,
              homePresenter: homePresenter,
              context: context,
              cartPresenter: cartPresenter,
              menuPresenter: menuPresenter,
            ),
            body: SafeArea(
              child: StreamBuilder<ProductsViewModel?>(
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
                    return MenuPage(
                        homePresenter.commandEntity?.isFixedCommandNumber ==
                            true);
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
