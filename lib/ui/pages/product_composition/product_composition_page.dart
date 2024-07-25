import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    ProductsViewModel selectedProduct = Get.arguments;

    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, productCompositionPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, productCompositionPresenter.mainErrorStream);

    return PopScope(
      onPopInvoked: (_) {
        productCompositionPresenter.updateSelectedFatherIndex(0);
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
                                indexOfSelectedFather: indexOfSelectedFather,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.67,
                          child: Column(
                            children: [
                              if (indexOfSelectedFather ==
                                  selectedProduct.childsComposition!.length)
                                const Center(child: Text("Quantidade")),
                              if (indexOfSelectedFather <
                                  selectedProduct.childsComposition!.length)
                                Childs(
                                  indexOfSelectedFather: indexOfSelectedFather,
                                  selectedProduct: selectedProduct,
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }),
    );
  }
}
