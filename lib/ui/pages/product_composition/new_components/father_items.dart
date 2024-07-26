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

  Color getItemColor(int index, BuildContext context) {
    if (index <= indexOfSelectedFather) {
      return Theme.of(context).primaryColorDark;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: selectedProduct.childsComposition!.length + 1,
        itemBuilder: (context, index) {
          if (index + 1 == selectedProduct.childsComposition!.length + 1) {
            return FatherItem(
              indexOfSelectedFather: index,
              selectedProduct: selectedProduct,
              father: null,
              itemColor: getItemColor(index, context),
            );
          }

          final father = selectedProduct.childsComposition![index];

          return FatherItem(
            father: father,
            indexOfSelectedFather: index,
            selectedProduct: selectedProduct,
            itemColor: getItemColor(index, context),
          );
        },
      ),
    );
  }
}
