import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';

class DetachItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  const DetachItems({
    required this.products,
    super.key,
  });

  @override
  State<DetachItems> createState() => _DetachItemsState();
}

class _DetachItemsState extends State<DetachItems> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 400.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items: widget.products.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: const BoxDecoration(color: Colors.amber),
              child: ProductItem(
                productsViewModel: i,
                productIsSelected: false,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
