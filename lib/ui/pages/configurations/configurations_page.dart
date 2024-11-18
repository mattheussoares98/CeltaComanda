import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({
    super.key,
  });

  @override
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage>
    with LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? homeLoadingSubscription;

  @override
  dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    homeLoadingSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    homeLoadingSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, configurationsPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, configurationsPresenter.mainErrorStream);
    homeLoadingSubscription =
        handleLoading(context, homePresenter.isLoadingStream);

    final buttons = allButtons(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        await printedProductsPresenter
            .loadPrinted(homePresenter.commandNumber!);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(R.string.configurations),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: hasMinWidth(context) ? 3 : 2,
              childAspectRatio: hasMinWidth(context) ? 5 : 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return buttons[index];
            },
          ),
        ),
      ),
    );
  }
}
