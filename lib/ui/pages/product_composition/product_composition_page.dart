import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../../adapters/adapters.dart';
import '../../mixins/mixins.dart';

class ProductCompositionPage extends StatefulWidget {
  const ProductCompositionPage({super.key});

  @override
  State<ProductCompositionPage> createState() => _ProductCompositionPageState();
}

class _ProductCompositionPageState extends State<ProductCompositionPage>
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

  bool getProducthasComment({
    required int indexOfLeftItem,
    required CommentsPresenter commentsPresenter,
  }) {
    if (selectedProduct!.childsComposition == null) {
      return commentsPresenter.productHasComment(
        internalCodeOnERP: selectedProduct!.InternalCodeOnERP!.toInt(),
        productName: selectedProduct!.Name,
      );
    } else if (indexOfLeftItem == selectedProduct!.childsComposition!.length) {
      return false;
    } else {
      return commentsPresenter.productHasComment(
        internalCodeOnERP: selectedProduct!
            .childsComposition![indexOfLeftItem].InternalCodeOnERPCodeChild!
            .toInt(),
        productName:
            selectedProduct!.childsComposition![indexOfLeftItem].ChildName!,
      );
    }
  }

  bool getShowComments({
    required AsyncSnapshot<bool> snapshowShowComments,
    required ProductsViewModel product,
    required int indexOfLeftItem,
  }) {
    if (product.childsComposition == null && indexOfLeftItem == 0) {
      return true;
    } else if (product.childsComposition == null && indexOfLeftItem == 1) {
      return false;
    } else {
      return snapshowShowComments.data ?? false;
    }
  }

  double totalLiquid = 0;
  int indexOfLeftItem = 0;

  void doOnBuildStreams({
    required InsertProductAdapter adapter,
    required AsyncSnapshot<double> snapshotTotalPrice,
    required AsyncSnapshot<ProductsViewModel?> snapshotSelectedProduct,
    required AsyncSnapshot<int> snapshotLeftItems,
  }) {
    Future.delayed(Duration.zero, () {
      adapter.updateTotalLiquid();
    });
    totalLiquid = snapshotTotalPrice.data ?? 0;
    adapter.updateSelectedProduct();

    if (snapshotSelectedProduct.hasData) {
      selectedProduct = snapshotSelectedProduct.data!;
    }
    indexOfLeftItem = snapshotLeftItems.data ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    InsertProductAdapter adapter = Get.arguments;
    selectedProduct = adapter.selectedProduct;

    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription = handleLoading(context, adapter.isLoadingStream);
    mainErrorSubscription = handleMainError(context, adapter.mainErrorStream);

    return PopScope(
      onPopInvoked: (_) {
        adapter.doOnClosePage();
      },
      child: StreamBuilder<double>(
          stream: adapter.totalPriceStream,
          builder: (context, snapshotTotalPrice) {
            return StreamBuilder<ProductsViewModel?>(
                stream: adapter.selectedComboxProductStream,
                builder: (context, snapshotSelectedProduct) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: StreamBuilder<int>(
                        stream: adapter.selectedItemIndexStream,
                        builder: (context, snapshotLeftItems) {
                          return StreamBuilder<bool>(
                              stream: adapter.showCommentsStream,
                              builder: (context, snapshowShowComments) {
                                doOnBuildStreams(
                                  adapter: adapter,
                                  snapshotTotalPrice: snapshotTotalPrice,
                                  snapshotSelectedProduct:
                                      snapshotSelectedProduct,
                                  snapshotLeftItems: snapshotLeftItems,
                                );
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        children: [
                                          NameImageAndComplement(
                                            selectedProduct: selectedProduct!,
                                          ),
                                          LeftItems(
                                            selectedProduct: selectedProduct!,
                                            indexOfSelectedFather:
                                                indexOfLeftItem,
                                            doScrollStream:
                                                adapter.doScrollStream,
                                            productHasComment:
                                                getProducthasComment(
                                              indexOfLeftItem: indexOfLeftItem,
                                              commentsPresenter:
                                                  commentsPresenter,
                                            ),
                                          ),
                                          Divider(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            thickness: 0.1,
                                            height: 1,
                                          ),
                                          TotalPriceCombox(
                                            totalLiquid: totalLiquid,
                                            totalProductsQuantity:
                                                adapter.totalProductsQuantity,
                                            selectedProduct: selectedProduct!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                if (selectedProduct!
                                                            .childsComposition !=
                                                        null &&
                                                    indexOfLeftItem <
                                                        selectedProduct!
                                                            .childsComposition!
                                                            .length)
                                                  ProductsAndCommentsButtons(
                                                    advanceSelectedIndex: adapter
                                                        .advanceSelectedIndex,
                                                    productHasComment:
                                                        getProducthasComment(
                                                      indexOfLeftItem:
                                                          indexOfLeftItem,
                                                      commentsPresenter:
                                                          commentsPresenter,
                                                    ),
                                                    indexOfSelectedFather:
                                                        indexOfLeftItem,
                                                    showComments:
                                                        getShowComments(
                                                      snapshowShowComments:
                                                          snapshowShowComments,
                                                      product: selectedProduct!,
                                                      indexOfLeftItem:
                                                          indexOfLeftItem,
                                                    ),
                                                  ),
                                                QuantityChildsAndComments(
                                                  selectedLeftIndex:
                                                      indexOfLeftItem,
                                                  selectedProduct:
                                                      selectedProduct!,
                                                  showComments: getShowComments(
                                                    snapshowShowComments:
                                                        snapshowShowComments,
                                                    product: selectedProduct!,
                                                    indexOfLeftItem:
                                                        indexOfLeftItem,
                                                  ),
                                                  callSetState: () {
                                                    setState(() {});
                                                  },
                                                  productHasComment:
                                                      getProducthasComment(
                                                    indexOfLeftItem:
                                                        indexOfLeftItem,
                                                    commentsPresenter:
                                                        commentsPresenter,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          AdvanceButton(
                                            totalPrice: totalLiquid,
                                            quantity:
                                                adapter.totalProductsQuantity,
                                            advanceSelectedIndex:
                                                adapter.advanceSelectedIndex,
                                            selectedProduct: selectedProduct!,
                                            leftSelectedIndex: indexOfLeftItem,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }),
                  );
                });
          }),
    );
  }
}
