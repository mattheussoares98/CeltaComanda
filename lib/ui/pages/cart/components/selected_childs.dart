import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class SelectedChilds extends StatelessWidget {
  final CartProductsViewModel cartProduct;
  final int productIndex;
  final int? selectedIndex;
  final int? selectedChildIndexComment;
  final void Function() updateSelectedIndex;
  final TextEditingController controller;
  final void Function() callSetState;
  final FocusNode focusNode;
  final void Function(int index) updateSelectedChildIndex;
  const SelectedChilds({
    required this.productIndex,
    required this.selectedIndex,
    required this.selectedChildIndexComment,
    required this.updateSelectedIndex,
    required this.controller,
    required this.callSetState,
    required this.focusNode,
    required this.cartProduct,
    required this.updateSelectedChildIndex,
    super.key,
  });

  final productAndCommentFlex = 2;
  final quantityFlex = 1;
  final priceFlex = 1;

  @override
  Widget build(BuildContext context) {
    InsertProductPresenter insertProductPresenter =
        Provider.of(context, listen: false);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: productAndCommentFlex,
                child: Text(
                  hasMinWidth(context)
                      ? R.string.selectedProductsAndComments
                      : R.string.productsAndComments,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: StringSize.size,
                  ),
                ),
              ),
              Expanded(
                flex: quantityFlex,
                child: Text(
                  hasMinWidth(context)
                      ? R.string.quantity
                      : R.string.quantityAbbreviated,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: StringSize.size,
                  ),
                ),
              ),
              Expanded(
                flex: priceFlex,
                child: Text(
                  R.string.price,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: StringSize.size,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: hasMinWidth(context) ? 8 : 2),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartProduct.Product.childsComposition!.length,
            itemBuilder: (context, i) {
              final child = cartProduct.Product.childsComposition![i];
              String childName = child.ChildName!;

              if (child.childs?.isNotEmpty == true &&
                  child.indexOfSelectedChild != null) {
                childName =
                    child.childs![child.indexOfSelectedChild!].ChildName!;
              }
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: productAndCommentFlex,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              childName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: StringSize.size,
                              ),
                            ),
                            if (child.commentFather != null)
                              Comment(comment: child.commentFather!),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: quantityFlex,
                          child: Text(
                            child.Quantity!.toBrazilianNumber(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: StringSize.size * 0.9,
                            ),
                          )),
                      Expanded(
                        flex: priceFlex,
                        child: Text(
                          (child.Quantity!.toDouble() *
                                  insertProductPresenter
                                      .calculateProductCompositionPrice(child)
                                      .toDouble())
                              .toString()
                              .toBrazilianNumber()
                              .addBrazilianCoin(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: StringSize.size * 0.9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (i < cartProduct.Product.childsComposition!.length - 1)
                    const Divider(
                      thickness: 0.2,
                      height: 10,
                    ),
                  ChangeComment(
                    productIndex: productIndex,
                    childIndex: i,
                    showTextFormField: productIndex == selectedIndex &&
                        selectedChildIndexComment == i,
                    updateSelectedIndex: () {
                      updateSelectedChildIndex(i);
                    },
                    controller: controller,
                    callSetState: callSetState,
                    focusNode: focusNode,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
