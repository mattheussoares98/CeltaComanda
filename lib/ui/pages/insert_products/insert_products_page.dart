import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
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
      debugPrint("Produto diferente");

      selectedProduct = Get.arguments;

      Future.delayed(Duration.zero, () {
        insertProductPresenter.updateSelectedProduct(selectedProduct!);
      });

      if (selectedProduct?.childsComposition != null) {
        for (var child in selectedProduct!.childsComposition!) {
          if (child.childs?.isEmpty == true) {
            child.indexOfSelectedChild = 0;
          }
        }
      }
    }

    if (snapshotTotalPrice.hasData && totalLiquid != snapshotTotalPrice.data) {
      debugPrint("Preço diferente");
      totalLiquid = snapshotTotalPrice.data!;
    }

    if (snapshotLeftItems.hasData &&
        snapshotLeftItems.data != indexOfLeftItem) {
      debugPrint("Índice diferente");
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
                  return Scaffold(
                    appBar: AppBar(),
                    body: StreamBuilder<int>(
                        stream: insertProductPresenter.selectedLeftIndexStream,
                        builder: (context, snapshotLeftItems) {
                          return StreamBuilder<bool>(
                              stream: insertProductPresenter.showCommentsStream,
                              builder: (context, snapshowShowComments) {
                                doOnBuildStreams(
                                  insertProductPresenter:
                                      insertProductPresenter,
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
                                                insertProductPresenter
                                                    .doScrollStream,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          if (selectedProduct
                                                      ?.childsComposition !=
                                                  null &&
                                              indexOfLeftItem <
                                                  selectedProduct!
                                                      .childsComposition!
                                                      .length)
                                            Text(
                                              selectedProduct!
                                                  .childsComposition![
                                                      indexOfLeftItem]
                                                  .ChildName!,
                                              style: TextStyle(
                                                fontSize:
                                                    getStringSize(context) *
                                                        1.4,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                              ),
                                            ),
                                          Expanded(
                                            child: QuantityChildsOrComments(
                                              selectedLeftIndex:
                                                  indexOfLeftItem,
                                              selectedProduct: selectedProduct!,
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
                                          ),
                                          AdvanceButton(
                                            totalPrice: totalLiquid,
                                            quantity: insertProductPresenter
                                                .totalProductsQuantity,
                                            advanceSelectedIndex: () {
                                              insertProductPresenter
                                                  .advanceLeftIndex(
                                                      commentsPresenter);
                                            },
                                            selectedProduct: selectedProduct!,
                                            leftSelectedIndex: indexOfLeftItem,
                                            productHasComment:
                                                getProducthasComment(
                                              indexOfLeftItem: indexOfLeftItem,
                                              commentsPresenter:
                                                  commentsPresenter,
                                            ),
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
