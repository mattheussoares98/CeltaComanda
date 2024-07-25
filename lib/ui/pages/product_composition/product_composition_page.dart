import 'package:clean_celta_mobile/ui/components/components.dart';
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

    return StreamBuilder<ProductsViewModel?>(
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
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: selectedProduct
                                          .childsComposition![
                                              indexOfSelectedFather]
                                          .childs
                                          ?.isEmpty ==
                                      true
                                  ? 1
                                  : selectedProduct
                                      .childsComposition![indexOfSelectedFather]
                                      .childs!
                                      .length,
                              itemBuilder: (context, childsIndex) {
                                // ProductCompositionViewModel child;
                                bool hasChilds = selectedProduct
                                        .childsComposition![
                                            indexOfSelectedFather]
                                        .childs
                                        ?.isNotEmpty ==
                                    true;

                                if (hasChilds) {
                                  // child = selectedProduct
                                  //     .childsComposition![0].childs![index];
                                } else {
                                  // child = selectedProduct.childsComposition![0];
                                }

                                if (hasChilds) {
                                  return const Text("Tem filho");
                                } else {
                                  return const Text("Não tem filho");
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          );
        });
  }
}

class FathersItems extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  const FathersItems({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: selectedProduct.childsComposition!.length + 1,
        itemBuilder: (context, index) {
          if (index + 1 == selectedProduct.childsComposition!.length + 1) {
            return FatherItem(
              isOptional: false,
              title: "QUANTIDADE",
              indexOfSelectedFather: index,
            );
          }
          final fatherComposition = selectedProduct.childsComposition![index];

          return FatherItem(
            title: fatherComposition.ChildName ?? "",
            isOptional: fatherComposition.IsOptionalItem == "true",
            indexOfSelectedFather: index,
          );
        },
      ),
    );
  }
}

class FatherItem extends StatelessWidget {
  final String title;
  final bool isOptional;
  final int indexOfSelectedFather;
  const FatherItem({
    required this.title,
    required this.isOptional,
    required this.indexOfSelectedFather,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return InkWell(
      onTap: () {
        debugPrint(indexOfSelectedFather.toString());
        productCompositionPresenter
            .updateSelectedFatherIndex(indexOfSelectedFather);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Container(
          color: Theme.of(context).primaryColorDark,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isOptional ? "Opcional" : "Obrigatório",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getStringSize(context) * 0.7,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NameImageAndComplement extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  const NameImageAndComplement({
    super.key,
    required this.selectedProduct,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              selectedProduct.Name,
              style: TextStyle(
                fontSize: getStringSize(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            ImageWidget(
              height: 160,
              width: 160,
              ean: selectedProduct.EanCode,
              plu: selectedProduct.PriceLookupCode,
              isAlcoholic: selectedProduct.IsAlcoholicProduct == "true",
              beginAnimation: 1.5,
              endAnimation: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 0, 3, 5),
              child: Text(
                selectedProduct.ProductComplement ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
