import '../../../ui/pages/pages.dart';
import '../../mixins/mixins.dart';

import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget with LoadingManager {
  final ProductDetailsPresenter presenter;
  const ProductDetailsPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    // final product = Get.arguments as ProductsViewModel;

    return const Scaffold(
        // body: ProductDetailItem(
        //   product: product,
        //   presenter: presenter,
        // ),
        );
  }
}
