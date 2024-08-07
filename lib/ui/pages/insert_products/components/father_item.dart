import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FatherItem extends StatelessWidget {
  final int indexOfLeftSelectedItem;
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel? father;
  final Color itemColor;
  final bool productHasComment;
  final bool showComments;
  const FatherItem({
    required this.father,
    required this.indexOfLeftSelectedItem,
    required this.selectedProduct,
    required this.itemColor,
    required this.productHasComment,
    required this.showComments,
    super.key,
  });

  String getIsOptionalOrObligatory() {
    if (selectedProduct.childsComposition == null &&
        productHasComment &&
        indexOfLeftSelectedItem == 0) {
      return "Opcional";
    } else if (selectedProduct.childsComposition == null) {
      return "Obrigatório";
    } else if (father == null || father?.IsOptionalItem == "false") {
      return "Obrigatório";
    } else {
      return "Opcional";
    }
  }

  String getLeftItemTitle(CommentsPresenter commentsPresenter) {
    if (selectedProduct.childsComposition != null) {
      if (indexOfLeftSelectedItem !=
          selectedProduct.childsComposition!.length) {
        return selectedProduct
            .childsComposition![indexOfLeftSelectedItem].ChildName!;
      } else if (indexOfLeftSelectedItem ==
          selectedProduct.childsComposition!.length) {
        return "QUANTIDADE";
      } else {
        return "COMENTÁRIOS";
      }
    } else {
      if (productHasComment && indexOfLeftSelectedItem == 0) {
        return "COMENTÁRIOS";
      } else {
        return "QUANTIDADE";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return InkWell(
      onTap: () {
        insertProductsPresenter.updateSelectedLeftItem(indexOfLeftSelectedItem);
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
                getLeftItemTitle(commentsPresenter),
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
