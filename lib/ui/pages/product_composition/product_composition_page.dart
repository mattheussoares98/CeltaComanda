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

  @override
  void dispose() {
    super.dispose();

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();
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
      ProductsViewModel selectedProduct, int indexOfSelectedFather) {
    ProductCompositionViewModel selectedFather =
        selectedProduct.childsComposition![0];

    if (indexOfSelectedFather < selectedProduct.childsComposition!.length) {
      selectedFather =
          selectedProduct.childsComposition![indexOfSelectedFather];
    }

    return selectedFather;
  }

  Widget rightSideTitleText(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
            fontSize: getStringSize(context),
          ),
        ),
      );

  Widget productOrCommentButton({
    required bool isSelected,
    required String text,
    required Function() onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).primaryColorDark : Colors.white,
        foregroundColor: isSelected
            ? Theme.of(context).primaryColorDark
            : Theme.of(context).primaryColorLight,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color:
              isSelected ? Colors.white : Theme.of(context).primaryColorLight,
        ),
      ),
    );
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 50),
                                            child: Column(
                                              children: [
                                                productOrCommentButton(
                                                  onPressed: () {
                                                    productCompositionPresenter
                                                        .updateSelectedFatherIndex(
                                                            indexOfSelectedFather);
                                                  },
                                                  isSelected: !showComments,
                                                  text: "Produto",
                                                ),
                                                const SizedBox(height: 10),
                                                if (productHasComment)
                                                  productOrCommentButton(
                                                    onPressed: () {
                                                      productCompositionPresenter.advanceFatherIndex(commentsPresenter);
                                                    },
                                                    isSelected: showComments,
                                                    text: "Comentário",
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                if (indexOfSelectedFather ==
                                                    selectedProduct
                                                        .childsComposition!
                                                        .length)
                                                  const Center(
                                                      child:
                                                          Text("Quantidade")),
                                                if (indexOfSelectedFather <
                                                        selectedProduct
                                                            .childsComposition!
                                                            .length &&
                                                    !showComments)
                                                  Column(
                                                    children: [
                                                      rightSideTitleText(getSelectedFather(
                                                                      selectedProduct,
                                                                      indexOfSelectedFather)
                                                                  .IsOptionalItem ==
                                                              "false"
                                                          ? "Selecione um produto!"
                                                          : "Se desejar, selecione um produto"),
                                                      Childs(
                                                        selectedFather:
                                                            getSelectedFather(
                                                                selectedProduct,
                                                                indexOfSelectedFather),
                                                        selectedProduct:
                                                            selectedProduct,
                                                      ),
                                                    ],
                                                  ),
                                                if (showComments &&
                                                    productHasComment)
                                                  Column(
                                                    children: [
                                                      rightSideTitleText(
                                                          "Se desejar, selecione um comentário"),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: CommentsList(
                                                          internalCodeOnErp: selectedProduct
                                                              .childsComposition![
                                                                  indexOfSelectedFather]
                                                              .InternalCodeOnERPCodeChild!
                                                              .toInt(),
                                                          selectedProductName:
                                                              selectedProduct
                                                                  .childsComposition![
                                                                      indexOfSelectedFather]
                                                                  .ChildName!,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
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
                                            onPressed: () {
                                              productCompositionPresenter
                                                  .advanceFatherIndex(
                                                      commentsPresenter);
                                            },
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
