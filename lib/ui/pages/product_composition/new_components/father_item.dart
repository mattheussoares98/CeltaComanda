import 'package:flutter/material.dart';

import '../../../../ui/helpers/sizes/sizes.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FatherItem extends StatelessWidget {
  final int indexOfSelectedFather;
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel? father;
  final Color itemColor;
  final ScrollController scrollController;
  const FatherItem({
    required this.father,
    required this.indexOfSelectedFather,
    required this.selectedProduct,
    required this.itemColor,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      color: itemColor,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            child: Text(
              indexOfSelectedFather + 1 ==
                      selectedProduct.childsComposition!.length + 1
                  ? "QUANTIDADE"
                  : father?.ChildName ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: getStringSize(context),
              ),
            ),
          ),
          FittedBox(
            child: Text(
              father?.IsOptionalItem == "true" ? "Opcional" : "Obrigatório",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Colors.grey,
                fontSize: getStringSize(context) * 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
