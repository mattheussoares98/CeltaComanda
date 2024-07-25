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
            body: Row(
              children: [
                Column(
                  children: [
                    NameImageAndComplement(
                      selectedProduct: selectedProduct,
                    ),
                    FathersItems(selectedProduct: selectedProduct)
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class FathersItems extends StatelessWidget {
  const FathersItems({
    super.key,
    required this.selectedProduct,
  });

  final ProductsViewModel selectedProduct;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: selectedProduct.childsComposition?.length,
        itemBuilder: (context, index) {
          final fatherComposition = selectedProduct.childsComposition?[index];

          return Container(
            color: Theme.of(context).primaryColorDark,
            child: Text(
              fatherComposition?.ChildName ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

class NameImageAndComplement extends StatelessWidget {
  const NameImageAndComplement({
    super.key,
    required this.selectedProduct,
  });

  final ProductsViewModel selectedProduct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  selectedProduct.Name,
                  style: TextStyle(
                    fontSize: getStringSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ImageWidget(
                height: 200,
                width: 200,
                ean: selectedProduct.EanCode,
                plu: selectedProduct.PriceLookupCode,
                isAlcoholic: selectedProduct.IsAlcoholicProduct == "true",
                beginAnimation: 1.5,
                endAnimation: 1,
              ),
              SizedBox(
                child: Text(
                  selectedProduct.ProductComplement ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
