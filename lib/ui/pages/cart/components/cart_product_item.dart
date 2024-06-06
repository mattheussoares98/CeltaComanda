import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
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
    required CartPresenter cartPresenter,
  }) {
    cartPresenter.addCartProductQuantity(widget.index);
  }

  void onPressedReduceQuantity({
    required CartPresenter cartPresenter,
  }) {
    if (widget.cartProduct.Quantity.toDouble() <= 1) {
      notificationDialog(
        context: context,
        titleMessage: "Remover produto do carrinho?",
        content: null,
        onPress: () async {
          cartPresenter.reduceCartProductQuantity(widget.index);
        },
      );
    } else {
      cartPresenter.reduceCartProductQuantity(widget.index);
    }
  }

  void onTapCommentIcon(CartPresenter cartPresenter) {
    cartPresenter.updateIndexOfSelectedProduct(widget.index);
    //criar teste pra essa alteração do índice do produto que foi selecionado
    if (widget.cartProduct.Comments != null) {
      setState(() {
        commentsController.text = widget.cartProduct.Comments!;
      });
    }

    if (cartPresenter.indexOfSelectedProduct == widget.index) {
      Future.delayed(const Duration(milliseconds: 300), () {
        FocusScope.of(context).requestFocus(commentsFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CartPresenter cartPresenter = Provider.of(context, listen: false);

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
                  cartPresenter: cartPresenter,
                );
              },
              onPressedAddQuantity: () {
                onPressedAddQuantity(
                  cartPresenter: cartPresenter,
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
            if (widget.cartProduct.Comments == null)
              const Expanded(
                child: Text(
                  "Não há comentário",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            if (widget.cartProduct.Comments != null)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CommentRichText(
                        comment: widget.cartProduct.Comments!,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        notificationDialog(
                          context: context,
                          titleMessage: "Excluir comentário?",
                          content: null,
                          onPress: () async {
                            await cartPresenter.updateCommentOfProductCart(
                              index: widget.index,
                              newComment: null,
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                onTapCommentIcon(cartPresenter);
              },
              child: Row(
                children: [
                  Icon(
                    color: Theme.of(context).colorScheme.primary,
                    Icons.add_comment,
                    size: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (cartPresenter.indexOfSelectedProduct == widget.index)
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
                  await cartPresenter.updateCommentOfProductCart(
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
