import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
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

  bool showComments = false;
  bool showObligatoryOptions = false;
  bool productHasComments = false;
  bool productHasObligatoryOptions = false;

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
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
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
    doOnBuildScreen(expansibleGroupFromProductPresenter);
  }

  void doOnBuildScreen(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    productHasObligatoryOptions =
        expansibleGroupFromProductPresenter.productHasObligatoryOption(
      indexOfChild: indexOfLeftItem,
      product: selectedProduct!,
    );

    productHasComments = expansibleGroupFromProductPresenter.productHasComment(
      indexOfChild: indexOfLeftItem,
      product: selectedProduct!,
    );

    showComments = false;
    showObligatoryOptions = false;

    if (indexOfLeftItem == 0) {
      if (productHasComments && selectedProduct!.childsComposition == null) {
        showComments = true;
      } else if (productHasObligatoryOptions) {
        showObligatoryOptions = true;
      }
    } else if (indexOfLeftItem == 1 && productHasObligatoryOptions) {
      showObligatoryOptions = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
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
          commentsPresenter: expansibleGroupFromProductPresenter,
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
                              expansibleGroupFromProductPresenter:
                                  expansibleGroupFromProductPresenter,
                            );
                            return Scaffold(
                              appBar: AppBar(
                                title: Text(selectedProduct!.Name),
                              ),
                              body: hasMinWidth(context)
                                  ? LandscapeInsertProductsPageBody(
                                      selectedProduct: selectedProduct!,
                                      indexOfLeftItem: indexOfLeftItem,
                                      totalLiquid: totalLiquid,
                                      snapshowShowComments:
                                          snapshowShowComments,
                                    )
                                  : PortraitInsertProductsPageBody(
                                      productHasComments: productHasComments,
                                      productHasObligatoryOptions:
                                          productHasObligatoryOptions,
                                      showObligatoryOptions:
                                          showObligatoryOptions,
                                      showComments: showComments,
                                      selectedProduct: selectedProduct!,
                                      indexOfLeftItem: indexOfLeftItem,
                                      totalLiquid: totalLiquid,
                                      snapshowShowComments:
                                          snapshowShowComments,
                                      showUpdateQuantity: _showUpdateQuantity(
                                        showComments: showComments,
                                        showObligatoryOptions:
                                            showObligatoryOptions,
                                        product: selectedProduct!,
                                        indexOfSelectedFather: indexOfLeftItem,
                                      ),
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

bool _showUpdateQuantity({
  required bool showComments,
  required bool showObligatoryOptions,
  required ProductsViewModel product,
  required int indexOfSelectedFather,
}) {
  if (showComments || showObligatoryOptions) {
    return false;
  } else if (product.childsComposition == null) {
    return true;
  } else if (product.childsComposition!.length == indexOfSelectedFather) {
    return true;
  } else {
    return false;
  }
}
