import 'package:battery_plus/battery_plus.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main/builders/builders.dart';
import '../../../main/factories/factories.dart';
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

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
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
        ExpansibleGroupFromProductPresenter
            expansibleGroupFromProductPresenter =
            Provider.of(context, listen: false);

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            await homePresenter.loadCommandData(
              menuPresenter: menuPresenter,
              printedProductsPresenter: printedProductsPresenter,
              cartPresenter: cartPresenter,
              expansibleGroupFromProductPresenter:
                  expansibleGroupFromProductPresenter,
              homePresenter: homePresenter,
            );
            // setState(() {});
          }
        });
      });
    }
  }

  final Battery _battery = Battery();

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    super.initState();
    _battery.batteryState.then(_updateBatteryState);
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen(_updateBatteryState);
  }

  int _lastUpdatedBatteryLevel = 0;

  void _updateBatteryState(BatteryState state) async {
    final int atualBatteryLevel = await _battery.batteryLevel;

    final differenceBetweenLastUpdatedAndAtualBattery =
        (_lastUpdatedBatteryLevel - atualBatteryLevel).abs();

    if (atualBatteryLevel > 20 ||
        _batteryState == BatteryState.charging ||
        differenceBetweenLastUpdatedAndAtualBattery < 5) {
      return;
    }

    _lastUpdatedBatteryLevel = atualBatteryLevel;

    Future.delayed(Duration.zero, () {
      showAlertMessage(
        context,
        "$atualBatteryLevel%. ${R.string.msgLowBatteryChargeDevice}",
        backgroundColor: Colors.red,
      );
    });

    if (_batteryState == state) return;
    _batteryState = state;
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
        onPopInvoked: (didPop) {
          notificationDialog(
            context: context,
            titleMessage: R.string.msgCloseApplication,
            content: Text(R.string.msgWantCloseApplication),
            onPress: () async {
              SystemNavigator.pop();
            },
          );
        },
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
          //não abre o drawer se arrastar a tela da esquerda pra direita bem no cantinho
          drawer: homePresenter.isFixedCommandNumber
              ? null
              : drawer(
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
