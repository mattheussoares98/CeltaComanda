import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../pages.dart';

class DetachItems extends StatelessWidget {
  final List<ProductsViewModel> products;
  final bool? showLargeImageOnTap;
  const DetachItems({
    required this.products,
    this.showLargeImageOnTap = true,
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
        autoPlayInterval: const Duration(seconds: 15),
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: products.map((product) {
        return InkWell(
          onTap: showLargeImageOnTap != true
              ? null
              : () {
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
                endAnimation: 1,
                isAlcoholic: product.IsAlcoholicProduct.toString() == "true",
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black12,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 30,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: FittedBox(
                    child: Text(
                      product.Name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
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
