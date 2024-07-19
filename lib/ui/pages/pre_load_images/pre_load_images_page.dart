import 'dart:async';

import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

import 'package:flutter/material.dart';

class PreLoadImagesPage extends StatefulWidget {
  final PageController? pageController;
  final bool? isFixedCommandNumber;
  const PreLoadImagesPage({
    this.pageController,
    this.isFixedCommandNumber,
    super.key,
  });

  @override
  State<PreLoadImagesPage> createState() => _PreLoadImagesPageState();
}

class _PreLoadImagesPageState extends State<PreLoadImagesPage>
    with UIErrorManager, LoadingManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;
  StreamSubscription? homeLoadingSubscription;

  @override
  void dispose() {
    super.dispose();
    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    homeLoadingSubscription?.cancel();
  }

  List<String> getAllPlus(MenuPresenter menuPresenter) {
    List<String> urls = [];

    final allProducts = menuPresenter.loadedMenu
        .expand((map) => map.values)
        .expand((lista) => lista)
        .toList();

    for (var product in allProducts) {
      urls.add(product.EanCode ?? product.PriceLookupCode);

      if (product.childsComposition != null) {
        for (var combox in product.childsComposition!) {
          urls.add(combox.PluChild!);

          if (combox.childs?.isNotEmpty == true) {
            for (var child in combox.childs!) {
              urls.add(child.PluChild!);
            }
          }
        }
      }
    }

    return urls;
  }

  List<String> getAllEans(MenuPresenter menuPresenter) {
    List<String> urls = [];

    final allProducts = menuPresenter.loadedMenu
        .expand((map) => map.values)
        .expand((lista) => lista)
        .toList();

    for (var product in allProducts) {
      if (product.EanCode != null) {
        urls.add(product.EanCode!);
      }
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, cartPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, cartPresenter.mainErrorStream);

    return Scaffold(
      body: Column(
        children: [
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: getAllPlus(menuPresenter).length,
              itemBuilder: (context, index) {
                final plu = getAllPlus(menuPresenter)[index];

                return ImageWidget(
                  ean: null,
                  plu: plu,
                  isAlcoholic: false,
                  height: 20,
                  width: 20,
                );
              }),
          GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: getAllEans(menuPresenter).length,
              itemBuilder: (context, index) {
                final ean = getAllEans(menuPresenter)[index];

                return ImageWidget(
                  ean: ean,
                  plu: "",
                  isAlcoholic: false,
                  height: 20,
                  width: 20,
                );
              }),
        ],
      ),
    );
  }
}
