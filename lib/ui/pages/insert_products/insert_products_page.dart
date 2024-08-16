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

  bool showObligatoryOptions = false;
  bool showComments = false;
  bool productHasComments = false;
  bool productHasObligatoryOptions = false;
  bool showUpdateQuantity = false;

  @override
  void dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
  }

  ProductsViewModel? selectedProduct;
  double totalLiquid = 0;
  int indexOfAtualFather = 0;

  double? previousTotalPrice;

  void doOnBuildStreams({
    required AsyncSnapshot<double> snapShowTotalPrice,
    required AsyncSnapshot<int> snapshotLeftItems,
    required InsertProductPresenter insertProductPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) {
    if (selectedProduct == null && Get.arguments != null) {
      selectedProduct = Get.arguments;

      Future.delayed(Duration.zero, () {
        insertProductPresenter.updateSelectedProduct(
          product: selectedProduct!,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
      });
    }

    if (snapShowTotalPrice.hasData && totalLiquid != snapShowTotalPrice.data) {
      totalLiquid = snapShowTotalPrice.data!;
    }

    if (snapshotLeftItems.hasData &&
        snapshotLeftItems.data != indexOfAtualFather) {
      indexOfAtualFather = snapshotLeftItems.data ?? 0;
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
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
        );
        expansibleGroupFromProductPresenter.unselectAllComments();
        expansibleGroupFromProductPresenter.unselectAllObligatoryOptions();
      },
      child: StreamBuilder<List<InsertProductsViewModel>?>(
          stream: insertProductPresenter.insertProductsViewModelStream,
          builder: (context, snapshotInsertProduct) {
            return StreamBuilder<double>(
                stream: insertProductPresenter.totalPriceStream,
                builder: (context, snapshotTotalPrice) {
                  return StreamBuilder<int>(
                      stream: insertProductPresenter.selectedLeftIndexStream,
                      builder: (context, snapshotLeftItems) {
                        doOnBuildStreams(
                          insertProductPresenter: insertProductPresenter,
                          snapShowTotalPrice: snapshotTotalPrice,
                          snapshotLeftItems: snapshotLeftItems,
                          expansibleGroupFromProductPresenter:
                              expansibleGroupFromProductPresenter,
                        );
                        return Scaffold(
                          appBar: AppBar(
                            title: FittedBox(
                              child: Text(selectedProduct!.Name),
                            ),
                          ),
                          body: hasMinWidth(context)
                              ? LandscapeInsertProductsPageBody(
                                  productHasComments: productHasComments,
                                  productHasObligatoryOptions:
                                      productHasObligatoryOptions,
                                  showObligatoryOptions: showObligatoryOptions,
                                  selectedProduct: selectedProduct!,
                                  indexOfLeftItem: indexOfAtualFather,
                                  totalLiquid: totalLiquid,
                                )
                              : PortraitInsertProductsPageBody(
                                  productHasComments: productHasComments,
                                  productHasObligatoryOptions:
                                      productHasObligatoryOptions,
                                  showObligatoryOptions: showObligatoryOptions,
                                  selectedProduct: selectedProduct!,
                                  indexOfLeftItem: indexOfAtualFather,
                                  totalLiquid: totalLiquid,
                                ),
                        );
                      });
                });
          }),
    );
  }
}
