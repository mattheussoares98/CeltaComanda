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
            Future.delayed(Duration.zero, () {
              adapter.updateTotalLiquid();
            });

            double totalLiquid = snapshotTotalPrice.data ?? 0;

            return StreamBuilder<ProductsViewModel?>(
                stream: adapter.selectedComboxProductStream,
                builder: (context, snapshot) {
                  adapter.updateSelectedProduct;

                  if (snapshot.hasData) {
                    selectedProduct = snapshot.data!;
                  }

                  return Scaffold(
                    appBar: AppBar(),
                    body: StreamBuilder<int>(
                        stream: adapter.selectedItemIndexStream,
                        builder: (context, snapshotLeftItems) {
                          final indexOfLeftItem = snapshotLeftItems.data ?? 0;

                          return StreamBuilder<bool>(
                              stream: adapter.showCommentsStream,
                              builder: (context, snapshowShowComments) {
                                final showComments =
                                    snapshowShowComments.data ?? false;
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
                                                if (indexOfLeftItem <
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
                                                    showComments: showComments,
                                                  ),
                                                QuantityChildsAndComments(
                                                  indexOfSelectedFather:
                                                      indexOfLeftItem,
                                                  selectedProduct:
                                                      selectedProduct!,
                                                  showComments: showComments,
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
