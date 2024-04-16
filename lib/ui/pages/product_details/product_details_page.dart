import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget with LoadingManager {
  final ProductDetailsPresenter presenter;
  const ProductDetailsPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    final productDetailsViewModel = Get.arguments as ProductsViewModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [CartIcon(goToCartPage: presenter.goToCartPage)],
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleLoading(context, presenter.isLoadingStream);

            return ListenableProvider(
              create: (_) => presenter,
              child: ProductDetailItem(productDetailsViewModel),
            );
          },
        ),
      ),
    );
  }
}
