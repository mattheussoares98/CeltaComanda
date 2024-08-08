import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class SelectedChilds extends StatelessWidget {
  final CartProductsViewModel cartProduct;
  const SelectedChilds({
    required this.cartProduct,
    super.key,
  });

  static const _productAndCommentFlex = 3;
  static const _quantityFlex = 1;
  static const _priceFlex = 1;

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
                flex: _productAndCommentFlex,
                child: Text(
                  hasMinWidth(context)
                      ? R.string.selectedProductsAndComments
                      : R.string.productsAndComments,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
              Expanded(
                flex: _quantityFlex,
                child: Text(
                  hasMinWidth(context) ? 'Quantidade' : "Qtd",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getStringSize(context),
                  ),
                ),
              ),
              Expanded(
                flex: _priceFlex,
                child: Text(
                  'Preço',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getStringSize(context),
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
                        flex: _productAndCommentFlex,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              childName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getStringSize(context) * 0.9,
                              ),
                            ),
                            if (child.commentFather != null)
                              Comment(comment: child.commentFather!),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: _quantityFlex,
                          child: Text(
                            child.Quantity!.toBrazilianNumber(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: getStringSize(context) * 0.9,
                            ),
                          )),
                      Expanded(
                        flex: _priceFlex,
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
                            fontSize: getStringSize(context) * 0.9,
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
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
