import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FatherItem extends StatelessWidget {
  final int indexOfSelectedFather;
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel? father;
  final Color itemColor;
  const FatherItem({
    required this.father,
    required this.indexOfSelectedFather,
    required this.selectedProduct,
    required this.itemColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return InkWell(
      onTap: () {
        productCompositionPresenter
            .updateSelectedFatherIndex(indexOfSelectedFather);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: Container(
          color: itemColor,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  indexOfSelectedFather + 1 ==
                          selectedProduct.childsComposition!.length + 1
                      ? "QUANTIDADE"
                      : father?.ChildName ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  father?.IsOptionalItem == "true" ? "Opcional" : "Obrigatório",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getStringSize(context) * 0.7,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
