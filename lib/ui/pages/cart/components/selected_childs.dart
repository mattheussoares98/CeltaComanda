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
          child: const Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Produto selecionados e comentários',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text('Quantidade',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text('Preço',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              childName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (child.commentFather != null)
                              Comment(comment: child.commentFather!),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Text(
                        child.Quantity!.toBrazilianNumber(),
                        textAlign: TextAlign.center,
                      )),
                      Expanded(
                        child: Text(
                          (child.Quantity!.toDouble() *
                                  insertProductPresenter
                                      .calculateProductCompositionPrice(child)
                                      .toDouble())
                              .toString()
                              .toBrazilianNumber()
                              .addBrazilianCoin(),
                          textAlign: TextAlign.center,
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
