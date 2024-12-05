// ignore_for_file: division_optimization

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
  int currentPart = 0;
  List<ProductsViewModel> allProducts = [];
  List<ProductsViewModel> productsShowing = [];
  int allProductsLength = 0;
  Timer? timer;
  int divideIntoTimes = 10;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        MenuPresenter menuPresenter = Provider.of(context, listen: false);

        allProducts = menuPresenter.loadedMenu
            .expand((map) => map.values)
            .expand((lista) => lista)
            .toList();

        allProductsLength = allProducts.length;

        setState(() {
          productsShowing = allProducts.sublist(
              currentPart, (allProductsLength / divideIntoTimes).toInt() + 1);
        });

        timer = Timer.periodic(Duration(seconds: 5), (_) async {
          if (currentPart == divideIntoTimes - 1) {
            menuPresenter.cancelPreloadImage();
          } else {
            setState(() {
              currentPart++;
              productsShowing = allProducts.sublist(currentPart,
                  (allProductsLength / divideIntoTimes).toInt() + currentPart);
            });
          }
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 0,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 1,
                childAspectRatio: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: productsShowing.length,
              itemBuilder: (context, index) {
                final product = productsShowing[index];

                return ImageWidget(
                  ean: null,
                  plu: product.PriceLookupCode,
                  selectedProduct: null,
                  height: 1,
                  width: 1,
                );
              }),
        ),
        Container(color: Colors.white),
      ],
    );
  }
}
