import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../pages.dart';

class DetachItems extends StatelessWidget {
  final List<ProductsViewModel> products;
  const DetachItems({
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);

    return CarouselSlider(
      options: CarouselOptions(
        height: double.infinity,
        autoPlay: false,
        viewportFraction: 1,
        enableInfiniteScroll: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 2000),
        autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
      ),
      items: products.map((product) {
        return InkWell(
          onTap: () {
            showLargeImage(
              context: context,
              ean: product.EanCode,
              productComplement: product.ProductComplement,
              plu: product.PriceLookupCode,
              menuPresenter: menuPresenter,
              productName: product.Name,
              selectedProduct: product,
              showInsertButton: true,
            );
          },
          child: ImageWidget(
            ean: product.EanCode,
            plu: product.PriceLookupCode,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            beginAnimation: 0.8,
            endAnimation: 1,
          ),
        );
      }).toList(),
    );
  }
}
