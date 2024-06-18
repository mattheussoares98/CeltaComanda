import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';
import '../../../components/components.dart';

class ConfirmedComboxItem extends StatelessWidget {
  final ConfirmedComboxViewModel confirmedCombox;
  final int index;
  const ConfirmedComboxItem({
    required this.confirmedCombox,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    TextEditingController commentsController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(
              ean: confirmedCombox.father.EanCode,
              plu: confirmedCombox.father.PriceLookupCode,
              showLargeImageInShowDialog: true,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                confirmedCombox.father.Name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            PriceAndUpdateProductQuantity(
              showDeleteIcon: confirmedCombox.quantity <= 1,
              showUpdateProductQuantity: true,
              price: confirmedCombox.totalPrice,
              totalLiquid:
                  confirmedCombox.quantity * confirmedCombox.totalPrice,
              onPressedReduceQuantity: () async {
                if (cartPresenter.confirmedCombox[index].quantity <= 1) {
                  notificationDialog(
                    context: context,
                    titleMessage: "Remover combo do carrinho?",
                    content: null,
                    onPress: () async {
                      await cartPresenter.reduceComboxQuantity(index);
                    },
                  );
                } else {
                  await cartPresenter.reduceComboxQuantity(index);
                }
              },
              onPressedAddQuantity: () async {
                await cartPresenter.addComboxQuantity(index);
              },
              productQuantity: confirmedCombox.quantity,
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: confirmedCombox.products.length,
          itemBuilder: (context, index) {
            final combox = confirmedCombox.products[index];

            ProductCompositionViewModel product;
            if (combox.childs?.isNotEmpty == true &&
                combox.indexOfSelectedChild != null) {
              product = combox.childs![combox.indexOfSelectedChild!];
            } else {
              product = combox;
            }

            return Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 65,
                        child: Text(
                          product.ChildName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 15,
                        child: Text(
                          combox.Quantity.toString().toBrazilianNumber(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 30,
                        child: Text(
                          (productCompositionPresenter
                                      .calculateProductPrice(combox) *
                                  combox.Quantity.toString().toDouble())
                              .toString()
                              .toBrazilianNumber()
                              .addBrazilianCoin(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Comment(
                  //   indexOfProduct: index,
                  //   indexOfSelectedProduct: cartPresenter.indexOfSelectedCombox,
                  //   comments: product.commentFather,
                  //   updateSelectedIndex: updateSelectedIndex,
                  //   commentsController: commentsController,
                  //   clearComment: () async {
                  //     await cartPresenter.updateCommentOfCombox(
                  //       indexOfCombox: index,
                  //       indexOfProduct: cartPresenter.indexOfSelectedCombox,
                  //       newComment: null,
                  //     );
                  //   },
                  //   updateComment: () async {
                  //     await cartPresenter.updateCommentOfCombox(
                  //       indexOfCombox: index,
                  //       indexOfProduct: cartPresenter.indexOfSelectedCombox,
                  //       newComment: commentsController.text,
                  //     );
                  //   },
                  // ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }
}
