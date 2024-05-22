import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../../../ui/components/components.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class SaleRequestTempProductItem extends StatefulWidget {
  final SaleRequestTempProductsViewModel saleRequestTemp;
  final int index;

  const SaleRequestTempProductItem({
    required this.saleRequestTemp,
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
    await saleRequestTempPresenter.addProductQuantity(
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      saleRequestProductTempId: int.parse(
        widget.saleRequestTemp.SaleRequestProductTempId,
      ),
      commandNumber: homePresenter.commandNumber!,
    );
  }

  Future<void> onPressedReduceQuantity({
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required HomePresenter homePresenter,
  }) async {
    double? quantityDouble = widget.saleRequestTemp.Quantity.toDouble();
    int quantityInt = quantityDouble.toInt();

    if (quantityInt > 1) {
      await saleRequestTempPresenter.subtractProductQuantity(
        url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
        saleRequestProductTempId:
            int.parse(widget.saleRequestTemp.SaleRequestProductTempId),
        productQuantity: quantityInt,
        commandNumber: homePresenter.commandNumber!,
      );
    } else {
      notificationDialog(
        context: context,
        titleMessage: "Deseja realmente remover o produto?",
        content: null,
        onPress: () async {
          await saleRequestTempPresenter.subtractProductQuantity(
            url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
            saleRequestProductTempId:
                int.parse(widget.saleRequestTemp.SaleRequestProductTempId),
            productQuantity: quantityInt,
            commandNumber: homePresenter.commandNumber!,
          );
        },
      );
    }
  }

  void onTapCommentIcon(SaleRequestTempPresenter saleRequestTempPresenter) {
    saleRequestTempPresenter.updateIndexOfSelectedProduct(widget.index);
    //criar teste pra essa alteração do índice do produto que foi selecionado
    if (widget.saleRequestTemp.Comments != null) {
      setState(() {
        commentsController.text = widget.saleRequestTemp.Comments!;
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
    ExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageWidget(
              ean: widget.saleRequestTemp.Product.EanCode,
              plu: widget.saleRequestTemp.Product.PriceLookupCode,
            ),
            const SizedBox(width: 3),
            ProductNamePluAndEan(
              nameComplete: widget.saleRequestTemp.Product.NameComplete,
              name: widget.saleRequestTemp.Product.Name,
              eanCode: widget.saleRequestTemp.Product.EanCode,
              priceLookupCode: widget.saleRequestTemp.Product.PriceLookupCode,
              comments: widget.saleRequestTemp.Comments,
              onTapCommentIcon: () async {
                onTapCommentIcon(saleRequestTempPresenter);
              },
            ),
            PriceAndUpdateProductQuantity(
              showUpdateProductQuantity: true,
              price: widget.saleRequestTemp.Value.toDouble(),
              totalLiquid: widget.saleRequestTemp.Quantity.toDouble() *
                  widget.saleRequestTemp.Value.toDouble(),
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
              productQuantity: widget.saleRequestTemp.Quantity.toDouble(),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            onTapCommentIcon(saleRequestTempPresenter);
          },
          child: Icon(
            color: Theme.of(context).colorScheme.primary,
            widget.saleRequestTemp.Comments == null
                ? Icons.add_comment
                : Icons.edit,
            size: 25,
          ),
        ),
        if (widget.saleRequestTemp.Comments != null)
          CommentRichText(comment: widget.saleRequestTemp.Comments!),
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

                  await saleRequestTempPresenter.updateComment(
                    comments: commentsController.text,
                    saleRequestProductTempId: int.parse(
                        widget.saleRequestTemp.SaleRequestProductTempId),
                    expansibleGroupsPresenter: expansibleGroupsPresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    saleRequestTempPresenter: saleRequestTempPresenter,
                    homePresenter: homePresenter,
                  );
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
