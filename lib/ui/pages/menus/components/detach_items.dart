import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';

class DetachItems extends StatefulWidget {
  final List<ProductsViewModel> products;
  final ProductsViewModel? selectedProduct;
  const DetachItems({
    required this.products,
    required this.selectedProduct,
    super.key,
  });

  @override
  State<DetachItems> createState() => _DetachItemsState();
}

class _DetachItemsState extends State<DetachItems> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 400.0),
      items: widget.products.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: const BoxDecoration(color: Colors.amber),
                child: Text(
                  'text $i',
                  style: const TextStyle(fontSize: 16.0),
                ));
          },
        );
      }).toList(),
    );
  }
}
