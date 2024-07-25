import 'package:flutter/material.dart';

import '../../pages.dart';

class FathersItems extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  const FathersItems({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: selectedProduct.childsComposition!.length + 1,
        itemBuilder: (context, index) {
          if (index + 1 == selectedProduct.childsComposition!.length + 1) {
            return FatherItem(
              isOptional: false,
              title: "QUANTIDADE",
              indexOfSelectedFather: index,
              fatherIsSelected: indexOfSelectedFather == index,
              selectedProduct: selectedProduct,
            );
          }
          final fatherComposition = selectedProduct.childsComposition![index];

          return FatherItem(
            title: fatherComposition.ChildName ?? "",
            isOptional: fatherComposition.IsOptionalItem == "true",
            indexOfSelectedFather: index,
            fatherIsSelected: indexOfSelectedFather == index,
            selectedProduct: selectedProduct,
          );
        },
      ),
    );
  }
}
