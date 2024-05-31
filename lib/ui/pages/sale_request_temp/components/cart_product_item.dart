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

  Future<void> onPressedAddQuantity({
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required HomePresenter homePresenter,
  }) async {
    // await saleRequestTempPresenter.addProductQuantity(
    //   url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
    //   saleRequestProductTempId: int.parse(
    //     widget.cartProduct.SaleRequestProductTempId,
    //   ),
    //   commandNumber: homePresenter.commandNumber!,
    // );
  }

  Future<void> onPressedReduceQuantity({
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required HomePresenter homePresenter,
  }) async {
    double? quantityDouble = widget.cartProduct.Quantity.toDouble();
    int quantityInt = quantityDouble.toInt();

    if (quantityInt > 1) {
      // await saleRequestTempPresenter.subtractProductQuantity(
      //   url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      //   saleRequestProductTempId:
      //       int.parse(widget.cartProduct.SaleRequestProductTempId),
      //   productQuantity: quantityInt,
      //   commandNumber: homePresenter.commandNumber!,
      // );
    } else {
      notificationDialog(
        context: context,
        titleMessage: "Deseja realmente remover o produto?",
        content: null,
        onPress: () async {
          // await saleRequestTempPresenter.subtractProductQuantity(
          //   url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
          //   saleRequestProductTempId:
          //       int.parse(widget.cartProduct.SaleRequestProductTempId),
          //   productQuantity: quantityInt,
          //   commandNumber: homePresenter.commandNumber!,
          // );
        },
      );
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
        commentsController.selection = TextSelection(
            baseOffset: 0, extentOffset: commentsController.text.length);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

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
            ProductNamePluAndEan(
              nameComplete: widget.cartProduct.Product.NameComplete,
              name: widget.cartProduct.Product.Name,
              eanCode: widget.cartProduct.Product.EanCode,
              priceLookupCode: widget.cartProduct.Product.PriceLookupCode,
              comments: widget.cartProduct.Comments,
              onTapCommentIcon: () async {
                onTapCommentIcon(saleRequestTempPresenter);
              },
            ),
            PriceAndUpdateProductQuantity(
              showUpdateProductQuantity: true,
              price: widget.cartProduct.Value.toDouble(),
              totalLiquid: widget.cartProduct.Quantity.toDouble() *
                  widget.cartProduct.Value.toDouble(),
              onPressedReduceQuantity: () async {
                await onPressedReduceQuantity(
                  saleRequestTempPresenter: saleRequestTempPresenter,
                  homePresenter: homePresenter,
                );
              },
              onPressedAddQuantity: () async {
                await onPressedAddQuantity(
                  saleRequestTempPresenter: saleRequestTempPresenter,
                  homePresenter: homePresenter,
                );
              },
              productQuantity: widget.cartProduct.Quantity.toDouble(),
            ),
          ],
        ),
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
          CommentRichText(comment: widget.cartProduct.Comments!),
        if (saleRequestTempPresenter.indexOfSelectedProduct == widget.index)
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: commentsFocusNode,
                  controller: commentsController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  commentsFocusNode.unfocus();

                  // await saleRequestTempPresenter.updateComment(
                  //   comments: commentsController.text,
                  //   saleRequestProductTempId: int.parse(
                  //       widget.cartProduct.SaleRequestProductTempId),
                  //   menuPresenter: menuPresenter,
                  //   printedProductsPresenter: printedProductsPresenter,
                  //   saleRequestTempPresenter: saleRequestTempPresenter,
                  //   homePresenter: homePresenter,
                  // );
                },
                child: const Text(
                  "Alterar\ncomentário",
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
