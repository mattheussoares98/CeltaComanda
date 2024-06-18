import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/pages/pages.dart';
import '../../../components/components.dart';

class ConfirmedComboxItem extends StatefulWidget {
  final ConfirmedComboxViewModel confirmedCombox;
  final int index;
  const ConfirmedComboxItem({
    required this.confirmedCombox,
    required this.index,
    super.key,
  });

  @override
  State<ConfirmedComboxItem> createState() => _ConfirmedComboxItemState();
}

class _ConfirmedComboxItemState extends State<ConfirmedComboxItem> {
  TextEditingController commentsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(
              ean: widget.confirmedCombox.father.EanCode,
              plu: widget.confirmedCombox.father.PriceLookupCode,
              showLargeImageInShowDialog: true,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                widget.confirmedCombox.father.Name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            PriceAndUpdateProductQuantity(
              showDeleteIcon: widget.confirmedCombox.quantity <= 1,
              showUpdateProductQuantity: true,
              price: widget.confirmedCombox.totalPrice,
              totalLiquid: widget.confirmedCombox.quantity *
                  widget.confirmedCombox.totalPrice,
              onPressedReduceQuantity: () async {
                if (cartPresenter.confirmedCombox[widget.index].quantity <= 1) {
                  notificationDialog(
                    context: context,
                    titleMessage: "Remover combo do carrinho?",
                    content: null,
                    onPress: () async {
                      await cartPresenter.reduceComboxQuantity(widget.index);
                    },
                  );
                } else {
                  await cartPresenter.reduceComboxQuantity(widget.index);
                }
              },
              onPressedAddQuantity: () async {
                await cartPresenter.addComboxQuantity(widget.index);
              },
              productQuantity: widget.confirmedCombox.quantity,
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.confirmedCombox.products.length,
          itemBuilder: (context, index) {
            final combox = widget.confirmedCombox.products[index];

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
                  Comment(
                    indexOfProduct: index,
                    indexOfSelectedProduct: cartPresenter.indexOfSelectedProductCombox,
                    comments: combox.commentFather,
                    updateSelectedIndex: () {
                      cartPresenter.updateIndexOfSelectedProductCombox(index);
                    },
                    commentsController: commentsController,
                    clearComment: () async {
                      await cartPresenter.updateCommentOfCombox(
                        indexOfCombox: widget.index,
                        indexOfProduct: index,
                        newComment: null,
                      );
                    },
                    updateComment: () async {
                      await cartPresenter.updateCommentOfCombox(
                        indexOfCombox: widget.index,
                        indexOfProduct: index,
                        newComment: commentsController.text,
                      );
                    },
                  ),
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
