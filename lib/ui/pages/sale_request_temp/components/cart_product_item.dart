import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class SaleRequestTempProductItem extends StatefulWidget {
  final CartProductsViewModel cartProduct;
  final int index;

  const SaleRequestTempProductItem({
    required this.cartProduct,
    required this.index,
    super.key,
  });

  @override
  State<SaleRequestTempProductItem> createState() =>
      _SaleRequestTempProductItemState();
}

class _SaleRequestTempProductItemState
    extends State<SaleRequestTempProductItem> {
  TextEditingController commentsController = TextEditingController();
  FocusNode commentsFocusNode = FocusNode();

  void onPressedAddQuantity({
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) {
    saleRequestTempPresenter.addCartProductQuantity(widget.index);
  }

  void onPressedReduceQuantity({
    required SaleRequestTempPresenter saleRequestTempPresenter,
  }) {
    if (widget.cartProduct.Quantity.toDouble() <= 1) {
      notificationDialog(
        context: context,
        titleMessage: "Remover produto do carrinho?",
        content: null,
        onPress: () async {
          saleRequestTempPresenter.reduceCartProductQuantity(widget.index);
        },
      );
    } else {
      saleRequestTempPresenter.reduceCartProductQuantity(widget.index);
    }
  }

  void onTapCommentIcon(SaleRequestTempPresenter saleRequestTempPresenter) {
    saleRequestTempPresenter.updateIndexOfSelectedProduct(widget.index);
    //criar teste pra essa alteração do índice do produto que foi selecionado
    if (widget.cartProduct.Comments != null) {
      setState(() {
        commentsController.text = widget.cartProduct.Comments!;
      });
    }

    if (saleRequestTempPresenter.indexOfSelectedProduct == widget.index) {
      Future.delayed(const Duration(milliseconds: 300), () {
        FocusScope.of(context).requestFocus(commentsFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(
              ean: widget.cartProduct.Product.EanCode,
              plu: widget.cartProduct.Product.PriceLookupCode,
              showLargeImageInShowDialog: true,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                widget.cartProduct.Product.Name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            PriceAndUpdateProductQuantity(
              showDeleteIcon: widget.cartProduct.Quantity.toDouble() <= 1,
              showUpdateProductQuantity: true,
              price: widget.cartProduct.Value.toDouble(),
              totalLiquid: widget.cartProduct.Quantity.toDouble() *
                  widget.cartProduct.Value.toDouble(),
              onPressedReduceQuantity: () {
                onPressedReduceQuantity(
                  saleRequestTempPresenter: saleRequestTempPresenter,
                );
              },
              onPressedAddQuantity: () {
                onPressedAddQuantity(
                  saleRequestTempPresenter: saleRequestTempPresenter,
                );
              },
              productQuantity: widget.cartProduct.Quantity.toDouble(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.cartProduct.Comments != null)
              Expanded(
                child: CommentRichText(
                  comment: widget.cartProduct.Comments!,
                ),
              ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    onTapCommentIcon(saleRequestTempPresenter);
                  },
                  child: Icon(
                    color: Theme.of(context).colorScheme.primary,
                    widget.cartProduct.Comments == null
                        ? Icons.add_comment
                        : Icons.edit,
                    size: 25,
                  ),
                ),
                if (widget.cartProduct.Comments != null)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        if (saleRequestTempPresenter.indexOfSelectedProduct == widget.index)
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: commentsFocusNode,
                  controller: commentsController,
                  maxLines: 8,
                  minLines: 1,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await saleRequestTempPresenter.updateCommentOfProductCart(
                    index: widget.index,
                    newComment: commentsController.text,
                  );

                  commentsFocusNode.unfocus();
                },
                child: const Text(
                  "Confirmar",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        const Divider(
          thickness: 0.2,
        )
      ],
    );
  }
}
