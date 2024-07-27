import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

import '../../../ui/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
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
  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
    _scrollController.dispose();
  }

  String getButtonText(int indexOfSelectedFather,
      ProductsViewModel selectedProduct, CommentsPresenter commentsPresenter) {
    if (indexOfSelectedFather == selectedProduct.childsComposition!.length) {
      return "INSERIR";
    } else if (selectedProduct
            .childsComposition![indexOfSelectedFather].IsOptionalItem ==
        "true") {
      return "PULAR";
    } else {
      return "AVANÇAR";
    }
  }

  ProductCompositionViewModel getSelectedFather(
    ProductsViewModel selectedProduct,
    int indexOfSelectedFather,
  ) {
    ProductCompositionViewModel selectedFather =
        selectedProduct.childsComposition![0];

    if (indexOfSelectedFather < selectedProduct.childsComposition!.length) {
      selectedFather =
          selectedProduct.childsComposition![indexOfSelectedFather];
    }

    return selectedFather;
  }

  @override
  Widget build(BuildContext context) {
    ProductsViewModel selectedProduct = Get.arguments;

    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, productCompositionPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, productCompositionPresenter.mainErrorStream);

    return PopScope(
      onPopInvoked: (_) {
        productCompositionPresenter.clearSelectedComboxData(
            product: selectedProduct, commentsPresenter: commentsPresenter);
      },
      child: StreamBuilder<ProductsViewModel?>(
          stream: productCompositionPresenter.selectedComboxProductStream,
          builder: (context, snapshot) {
            productCompositionPresenter.updateSelectedProduct(selectedProduct);

            if (snapshot.hasData) {
              selectedProduct = snapshot.data!;
            }

            return Scaffold(
              appBar: AppBar(),
              body: StreamBuilder<int>(
                  stream: productCompositionPresenter.selectedFatherIndexStream,
                  builder: (context, snapshotSelectedFather) {
                    final indexOfSelectedFather =
                        snapshotSelectedFather.data ?? 0;

                    bool productHasComment =
                        commentsPresenter.productHasComment(
                      internalCodeOnERP: selectedProduct
                          .childsComposition![indexOfSelectedFather]
                          .InternalCodeOnERPCodeChild!
                          .toInt(),
                      productName: selectedProduct
                          .childsComposition![indexOfSelectedFather].ChildName!,
                    );

                    return StreamBuilder<bool>(
                        stream: productCompositionPresenter.showCommentsStream,
                        builder: (context, snapshowShowComments) {
                          final showComments =
                              snapshowShowComments.data ?? false;
                          return Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.33,
                                child: Column(
                                  children: [
                                    NameImageAndComplement(
                                      selectedProduct: selectedProduct,
                                    ),
                                    FathersItems(
                                      scrollController: _scrollController,
                                      selectedProduct: selectedProduct,
                                      indexOfSelectedFather:
                                          indexOfSelectedFather,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.67,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          ProductsAndCommentsButtons(
                                            productHasComment:
                                                productHasComment,
                                            indexOfSelectedFather:
                                                indexOfSelectedFather,
                                            scrollController: _scrollController,
                                            showComments: showComments,
                                          ),
                                          QuantityChildsAndComments(
                                            indexOfSelectedFather:
                                                indexOfSelectedFather,
                                            selectedProduct: selectedProduct,
                                            showComments: showComments,
                                            callSetState: () {
                                              setState(() {});
                                            },
                                            productHasComment:
                                                productHasComment,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: productCompositionPresenter
                                                    .fatherIsValid(
                                                        getSelectedFather(
                                                            selectedProduct,
                                                            indexOfSelectedFather))
                                                ? () {
                                                    productCompositionPresenter
                                                        .advanceFatherIndex(
                                                            commentsPresenter);
                                                    productCompositionPresenter
                                                        .scrollToIndex(
                                                            _scrollController);
                                                  }
                                                : null,
                                            child: Text(
                                              getButtonText(
                                                indexOfSelectedFather,
                                                selectedProduct,
                                                commentsPresenter,
                                              ),
                                            ),
                                          ),
                                        ],
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
          }),
    );
  }
}
