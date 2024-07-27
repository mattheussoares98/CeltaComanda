import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/sizes/sizes.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class LeftItem extends StatelessWidget {
  final int indexOfLeftSelectedItem;
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel? father;
  final Color itemColor;
  const LeftItem({
    required this.father,
    required this.indexOfLeftSelectedItem,
    required this.selectedProduct,
    required this.itemColor,
    super.key,
  });

  String getIsOptionalOrObligatory() {
    if (father == null || father?.IsOptionalItem == "false") {
      return "Obrigatório";
    } else {
      return "Opcional";
    }
  }

  String getLeftItemTitle() {
    if (selectedProduct.childsComposition != null) {
      if (indexOfLeftSelectedItem ==
          selectedProduct.childsComposition!.length) {
        return "QUANTIDADE";
      } else {
        return father!.ChildName ?? "";
      }
    } else {
      if (indexOfLeftSelectedItem == 0) {
        return selectedProduct.Name;
      } else {
        return "QUANTIDADE";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return InkWell(
      onTap: () {
        if (selectedProduct.childsComposition != null) {
          productCompositionPresenter
              .updateSelectedLeftItem(indexOfLeftSelectedItem);
        }
      },
      child: Container(
        height: 42,
        color: itemColor,
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Text(
                getLeftItemTitle(),
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
                getIsOptionalOrObligatory(),
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
