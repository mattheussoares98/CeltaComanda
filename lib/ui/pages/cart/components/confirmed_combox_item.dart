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

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 220, 218, 218)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x33000000),
            offset: Offset(-3, -1),
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
                  if (cartPresenter.confirmedCombox[widget.index].quantity <=
                      1) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageWidget(
                          ean: null,
                          plu: product.PluChild.toString(),
                          showLargeImageInShowDialog: true,
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 65,
                          child: Text(
                            product.ChildName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Qtd: ${combox.Quantity.toString().toBrazilianNumber()}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    Comment(
                      indexOfProduct: index,
                      indexOfSelectedProduct:
                          cartPresenter.indexOfSelectedProductCombox,
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
        ],
      ),
    );
  }
}
