import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../pages.dart';
import '../../mixins/mixins.dart';

class InsertProductsPage extends StatefulWidget {
  const InsertProductsPage({super.key});

  @override
  State<InsertProductsPage> createState() => _InsertProductsPageState();
}

class _InsertProductsPageState extends State<InsertProductsPage>
    with KeyboardManager, LoadingManager, UIErrorManager {
  StreamSubscription? loadingSubscription;
  StreamSubscription? mainErrorSubscription;

  @override
  void dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  ProductsViewModel? selectedProduct;
  double totalLiquid = 0;
  int indexOfLeftItem = 0;

  double? previousTotalPrice;

  void doOnBuildStreams({
    required AsyncSnapshot<double> snapshotTotalPrice,
    required AsyncSnapshot<ProductsViewModel?> snapshotSelectedProduct,
    required AsyncSnapshot<int> snapshotLeftItems,
    required InsertProductPresenter insertProductPresenter,
  }) {
    if (snapshotSelectedProduct.hasData &&
            snapshotSelectedProduct.data != selectedProduct ||
        (selectedProduct == null && Get.arguments != null)) {
      selectedProduct = Get.arguments;

      Future.delayed(Duration.zero, () {
        insertProductPresenter.updateSelectedProduct(selectedProduct!);
      });
    }

    if (snapshotTotalPrice.hasData && totalLiquid != snapshotTotalPrice.data) {
      totalLiquid = snapshotTotalPrice.data!;
    }

    if (snapshotLeftItems.hasData &&
        snapshotLeftItems.data != indexOfLeftItem) {
      indexOfLeftItem = snapshotLeftItems.data ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, insertProductPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, insertProductPresenter.mainErrorStream);

    return PopScope(
      onPopInvoked: (_) {
        insertProductPresenter.clearData(
          product: selectedProduct!,
          commentsPresenter: commentsPresenter,
        );
      },
      child: StreamBuilder<double>(
          stream: insertProductPresenter.totalPrice,
          builder: (context, snapshotTotalPrice) {
            return StreamBuilder<ProductsViewModel?>(
                stream: insertProductPresenter.selectedProductStream,
                builder: (context, snapshotSelectedProduct) {
                  return StreamBuilder<int>(
                      stream: insertProductPresenter.selectedLeftIndexStream,
                      builder: (context, snapshotLeftItems) {
                        return StreamBuilder<bool>(
                          stream: insertProductPresenter.showCommentsStream,
                          builder: (context, snapshowShowComments) {
                            doOnBuildStreams(
                              insertProductPresenter: insertProductPresenter,
                              snapshotTotalPrice: snapshotTotalPrice,
                              snapshotSelectedProduct: snapshotSelectedProduct,
                              snapshotLeftItems: snapshotLeftItems,
                            );
                            return Scaffold(
                              appBar: AppBar(),
                              body: InsertProductsPageBody(
                                selectedProduct: selectedProduct!,
                                indexOfLeftItem: indexOfLeftItem,
                                totalLiquid: totalLiquid,
                                snapshowShowComments: snapshowShowComments,
                              ),
                            );
                          },
                        );
                      });
                });
          }),
    );
  }
}
