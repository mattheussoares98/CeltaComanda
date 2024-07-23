// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../pages.dart';

class Composition extends StatefulWidget {
  final ProductsViewModel selectedComboxProduct;
  const Composition({
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
            itemCount: widget.selectedComboxProduct.childsComposition?.length,
            itemBuilder: (context, index) {
              father = widget.selectedComboxProduct.childsComposition?[index];

              if (father?.childs?.isEmpty == true &&
                  widget.selectedComboxProduct.childsComposition != null) {
                return FathersWithoutChilds(
                  selectedComboxProduct: widget.selectedComboxProduct,
                  father: father!,
                  productsCompositionsViewModel:
                      widget.selectedComboxProduct.childsComposition!,
                );
              }

              if (father != null) {
                return FathersWithChilds(
                  selectedComboxProduct: widget.selectedComboxProduct,
                  father: father!,
                  productsCompositions:
                      widget.selectedComboxProduct.childsComposition!,
                  index: index,
                );
              }

              return const SizedBox();
            },
          ),
        ),
        if (widget.selectedComboxProduct.childsComposition != null)
          SaveComboxButton(
            productsCompositions:
                widget.selectedComboxProduct.childsComposition!,
            selectedComboxProduct: widget.selectedComboxProduct,
          ),
      ],
    );
  }
}
