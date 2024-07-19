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
  ProductsViewModel? selectedComboxProduct;

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
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    loadingSubscription?.cancel();
    mainErrorSubscription?.cancel();

    loadingSubscription =
        handleLoading(context, productCompositionPresenter.isLoadingStream);
    mainErrorSubscription =
        handleMainError(context, productCompositionPresenter.mainErrorStream);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            textAlign: TextAlign.center,
            selectedComboxProduct?.Name ?? "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: hasMinWidth(context) ? 30 : 20,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<ProductCompositionViewModel>>(
            stream: productCompositionPresenter.productsCompositionStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // return ReloadScreen(
                //   error: '${snapshot.error}',
                //   reload: () async =>
                //       await productCompositionPresenter.loadProductComposition(
                //     url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
                //     enterpriseId: EnterpriseDataBuilder
                //         .enterpriseDataEntity!.enterpriseId!,
                //     internalCodeOnErp:
                //         int.parse(selectedComboxProduct!.InternalCodeOnERP!),
                //   ),
                // );
              }
              if (snapshot.hasData) {
                return Composition(
                  selectedComboxProduct: selectedComboxProduct!,
                  productsCompositions: snapshot.data!,
                );
              }
              return const SizedBox(height: 0);
            }),
      ),
    );
  }
}
