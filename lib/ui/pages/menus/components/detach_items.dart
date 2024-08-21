import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../pages.dart';

class DetachItems extends StatelessWidget {
  final List<ProductsViewModel> products;
  final bool? popOnImageClick;
  const DetachItems({
    required this.products,
    this.popOnImageClick = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MenuPresenter menuPresenter = Provider.of(context);

    return CarouselSlider(
      options: CarouselOptions(
        height: double.infinity,
        autoPlay: true,
        viewportFraction: 1,
        enableInfiniteScroll: true,
        autoPlayInterval: const Duration(seconds: 7),
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: products.map((product) {
        return InkWell(
          onTap: () {
            if (popOnImageClick == true) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
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
          child: Stack(
            children: [
              ImageWidget(
                ean: product.EanCode,
                plu: product.PriceLookupCode,
                width: MediaQuery.of(context).size.width * 0.66,
                height: MediaQuery.of(context).size.height,
                beginAnimation: 1,
                endAnimation: 0.7,
                selectedProduct: product,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black45,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: hasMinWidth(context) ? 30 : 5,
                child: Text(
                  product.Name.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: hasMinWidth(context) ? 40 : 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
