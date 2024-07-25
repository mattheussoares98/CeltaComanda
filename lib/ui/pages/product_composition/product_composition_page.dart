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
          return Scaffold(
            appBar: AppBar(
              title: Text(
                textAlign: TextAlign.center,
                selectedProduct.Name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: hasMinWidth(context) ? 30 : 20,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Composition(
                    selectedComboxProduct: snapshot.data ?? selectedProduct,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
