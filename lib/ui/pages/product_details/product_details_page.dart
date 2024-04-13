import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';
import './components/components.dart';
import './products_details.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget
    with LoadingManager, NavigationManager {
  final ProductDetailsPresenter presenter;
  const ProductDetailsPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    final productDetailsViewModel = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        // actions: [
        //   CartIcon(presenter: ),
        // ],
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Builder(
          builder: (context) {
            handleLoading(context, presenter.isLoadingStream);
            handleNavigation(presenter.navigateToStream);

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
