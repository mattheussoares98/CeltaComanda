// ignore_for_file: use_build_context_synchronously

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

  bool applicationIsInLatestVersion = true;
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        HomePresenter homePresenter = Provider.of(context, listen: false);
        applicationIsInLatestVersion =
            await homePresenter.applicationIsInLatestVersion();
        setState(() {});
      }
    });
  }

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
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(R.string.configurations +
              (homePresenter.commandEntity?.pdv?.PdvNumber != null
                  ? "  ${R.string.pdv} ${homePresenter.commandEntity!.pdv!.PdvNumber!.toInt()}"
                  : "")),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (homePresenter.commandEntity?.commandNumber != null) {
                await printedProductsPresenter.loadPrinted(
                  homePresenter.commandEntity!.commandNumber!,
                );
              }
              Navigator.of(context).pop();
              Future.delayed(Duration.zero, () => setState(() {}));
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!applicationIsInLatestVersion &&
                    !homePresenter.isGeneratingVersionToRede &&
                    !homePresenter.isGeneratingVersionToGetNet)
                  const UpdateApplicationButton(),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ScreenSize.hasMinWidth ? 3 : 2,
                    childAspectRatio: ScreenSize.hasMinWidth ? 5 : 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    return buttons[index];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
