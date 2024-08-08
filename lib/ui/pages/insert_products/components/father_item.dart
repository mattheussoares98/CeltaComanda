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
      return R.string.optional;
    } else if (selectedProduct.childsComposition == null) {
      return R.string.obligatory;
    } else if (father == null || father?.IsOptionalItem == "false") {
      return R.string.obligatory;
    } else {
      return R.string.optional;
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
        return R.string.quantity.toUpperCase();
      } else {
        return "COMENTÁRIOS";
      }
    } else {
      if (productHasComment && indexOfLeftSelectedItem == 0) {
        return "COMENTÁRIOS";
      } else {
        return R.string.quantity.toUpperCase();
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
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: getLeftItemTitle(commentsPresenter),
                  children: selectedProduct.childsComposition == null
                      ? null
                      : <TextSpan>[
                          TextSpan(
                            text: showComments ? "  (COMENTÁRIO)" : null,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                ),
              ),
            ),
            FittedBox(
              child: Text(
                getIsOptionalOrObligatory(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.white,
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
