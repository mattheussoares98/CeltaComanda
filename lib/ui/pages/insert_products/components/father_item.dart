import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class FatherItem extends StatelessWidget {
  final int indexOfSelectedFather;
  final int atualIndex;
  final ProductsViewModel selectedProduct;
  final ProductCompositionViewModel? father;
  final Color itemColor;
  const FatherItem({
    required this.father,
    required this.atualIndex,
    required this.indexOfSelectedFather,
    required this.selectedProduct,
    required this.itemColor,
    super.key,
  });

  String getIsOptionalOrObligatory(
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter,
  ) {
    if (selectedProduct.childsComposition == null &&
        expansibleGroupFromProductPresenter.productHasComment(
          product: selectedProduct,
          indexOfChild: 0,
        ) &&
        atualIndex == 0) {
      return R.string.optional;
    } else if (selectedProduct.childsComposition == null) {
      return R.string.obligatory;
    } else if (father == null || father?.IsOptionalItem == "false") {
      return R.string.obligatory;
    } else {
      return R.string.optional;
    }
  }

  String getLeftItemTitle(
      ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter) {
    if (selectedProduct.childsComposition != null) {
      if (atualIndex != selectedProduct.childsComposition!.length) {
        return selectedProduct.childsComposition![atualIndex].ChildName!;
      } else if (atualIndex == selectedProduct.childsComposition!.length) {
        return R.string.quantity.toUpperCase();
      } else {
        return R.string.comments.toUpperCase();
      }
    } else {
      final productHasComment =
          expansibleGroupFromProductPresenter.productHasComment(
        product: selectedProduct,
        indexOfChild: -1,
      );

      final productHasObligatoryOption =
          expansibleGroupFromProductPresenter.productHasObligatoryOption(
        product: selectedProduct,
        indexOfChild: -1,
      );

      if (atualIndex == 0) {
        if (productHasComment) {
          return R.string.comments.toUpperCase();
        } else if (productHasObligatoryOption) {
          return R.string.obligatoryOptions.toUpperCase();
        } else {
          return R.string.quantity.toUpperCase();
        }
      } else if (atualIndex == 1) {
        if (productHasComment && productHasObligatoryOption) {
          return R.string.obligatoryOptions.toUpperCase();
        } else {
          return R.string.quantity.toUpperCase();
        }
      }

      return R.string.quantity.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);

    return InkWell(
      onTap: () {
        insertProductPresenter.updateFatherIndex(atualIndex);
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
                  text: getLeftItemTitle(expansibleGroupFromProductPresenter),
                  children: selectedProduct.childsComposition == null
                      ? null
                      : <TextSpan>[
                          TextSpan(
                            text: insertProductPresenter.getShowComments(
                                      expansibleGroupFromProductPresenter,
                                    ) &&
                                    atualIndex == indexOfSelectedFather
                                ? "  (${R.string.comment.toUpperCase()})"
                                : null,
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
                getIsOptionalOrObligatory(expansibleGroupFromProductPresenter),
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
