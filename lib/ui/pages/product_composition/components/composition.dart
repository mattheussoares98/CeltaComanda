// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../pages.dart';

class Composition extends StatefulWidget {
  final List<ProductCompositionViewModel> productsCompositions;
  final ProductsViewModel selectedComboxProduct;
  const Composition({
    required this.productsCompositions,
    required this.selectedComboxProduct,
    super.key,
  });

  @override
  State<Composition> createState() => _CompositionState();
}

class _CompositionState extends State<Composition> {
  ProductCompositionViewModel? father;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.productsCompositions.length,
            itemBuilder: (context, index) {
              father = widget.productsCompositions[index];

              if (father!.childs?.isEmpty == true) {
                return FathersWithoutChilds(
                  selectedComboxProduct: widget.selectedComboxProduct,
                  father: father!,
                  productsCompositionsViewModel: widget.productsCompositions,
                );
              }

              return FathersWithChilds(
                selectedComboxProduct: widget.selectedComboxProduct,
                father: father!,
                productsCompositions: widget.productsCompositions,
                index: index,
              );
            },
          ),
        ),
        SaveComboxButton(
          productsCompositions: widget.productsCompositions,
          selectedComboxProduct: widget.selectedComboxProduct,
        ),
      ],
    );
  }
}
