import 'package:clean_celta_mobile/ui/helpers/sizes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FatherItem extends StatelessWidget {
  final int indexOfSelectedFather;
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel? father;
  final Color itemColor;
  final Function() scrollToIndex;
  const FatherItem({
    required this.father,
    required this.indexOfSelectedFather,
    required this.selectedProduct,
    required this.itemColor,
    required this.scrollToIndex,
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
        scrollToIndex();
      },
      child: Container(
        height: 40,
        color: itemColor,
        margin: const EdgeInsets.only(bottom: 2),
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
      ),
    );
  }
}
