import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';

import 'package:flutter/material.dart';

class PreLoadImagesPage extends StatefulWidget {
  final PageController? pageController;
  final bool? isFixedCommandNumber;
  const PreLoadImagesPage({
    this.pageController,
    this.isFixedCommandNumber,
    super.key,
  });

  @override
  State<PreLoadImagesPage> createState() => _PreLoadImagesPageState();
}

class _PreLoadImagesPageState extends State<PreLoadImagesPage>
    with UIErrorManager, LoadingManager {
  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    final allProducts = menuPresenter.loadedMenu
        .expand((map) => map.values)
        .expand((lista) => lista)
        .toList();

    return Stack(
      children: [
        SizedBox(
          height: 0,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 1,
                childAspectRatio: 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                final product = allProducts[index];

                return ImageWidget(
                  ean: null,
                  plu: product.PriceLookupCode,
                  selectedProduct: null,
                  height: 1,
                  width: 1,
                );
              }),
        ),
        Container(color: Colors.white),
      ],
    );
  }
}
