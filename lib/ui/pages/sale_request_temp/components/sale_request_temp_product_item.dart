import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../main/builders/builders.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../pages.dart';

class SaleRequestTempProductItem extends StatefulWidget {
  final SaleRequestTempProductsViewModel product;
  final int index;

  const SaleRequestTempProductItem({
    required this.product,
    required this.index,
    super.key,
  });

  @override
  State<SaleRequestTempProductItem> createState() =>
      _SaleRequestTempProductItemState();
}

class _SaleRequestTempProductItemState
    extends State<SaleRequestTempProductItem> {
  Future<void> onPressedAddQuantity({
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  }) async {
    await saleRequestTempPresenter.addProductQuantity(
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      saleRequestProductTempId: int.parse(
        widget.product.SaleRequestProductTempId,
      ),
      commandNumber: expansibleGroupsPresenter.commandNumber!,
    );
  }

  Future<void> onPressedReduceQuantity({
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required ExpansibleGroupsPresenter expansibleGroupsPresenter,
  }) async {
    double? quantityDouble =
        double.tryParse(widget.product.Quantity.replaceAll(RegExp(r','), '.'));
    int quantityInt = quantityDouble!.toInt();

    await saleRequestTempPresenter.subtractProductQuantity(
      url: EnterpriseDataBuilder.enterpriseDataEntity!.url!,
      saleRequestProductTempId:
          int.parse(widget.product.SaleRequestProductTempId),
      productQuantity: quantityInt,
      commandNumber: expansibleGroupsPresenter.commandNumber!,
    );
  }

  void onTapCommentIcon({
    required SaleRequestTempPresenter saleRequestTempPresenter,
    required TextEditingController commentsController,
    required FocusNode commentsFocusNode,
  }) {
    saleRequestTempPresenter.updateIndexOfSelectedProduct(widget.index);
    //criar teste pra essa alteração do índice do produto que foi selecionado
    if (widget.product.Comments != null) {
      setState(() {
        commentsController.text = widget.product.Comments!;
      });
      FocusScope.of(context).requestFocus(commentsFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    GetxSaleRequestTempPresenter saleRequestTempPresenter =
        Provider.of(context, listen: false);
    GetxExpansibleGroupsPresenter expansibleGroupsPresenter =
        Provider.of(context, listen: false);

    TextEditingController commentsController = TextEditingController();
    FocusNode commentsFocusNode = FocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetails(
          commentsFocusNode: commentsFocusNode,
          showFormFieldUpdateComment:
              saleRequestTempPresenter.indexOfSelectedProduct == widget.index,
          commentsController: commentsController,
          onTapCommentIcon: () {
            onTapCommentIcon(
              saleRequestTempPresenter: saleRequestTempPresenter,
              commentsController: commentsController,
              commentsFocusNode: commentsFocusNode,
            );
          },
          isPrintedProducts: false,
          Product: widget.product.Product,
          onPressedAddQuantity: () async {
            await onPressedAddQuantity(
              saleRequestTempPresenter: saleRequestTempPresenter,
              expansibleGroupsPresenter: expansibleGroupsPresenter,
            );
          },
          onPressedReduceQuantity: () async {
            await onPressedReduceQuantity(
              saleRequestTempPresenter: saleRequestTempPresenter,
              expansibleGroupsPresenter: expansibleGroupsPresenter,
            );
          },
          onPressedRemoveProduct: null,
          quantity: widget.product.Quantity,
          value: widget.product.Value,
          totalLiquid: widget.product.TotalLiquid,
          comments: widget.product.Comments,
        ),
        // if (product.Comments != null) Text("Comments: ${product.Comments}"),
        // Text("SaleRequestProductTempId ${product.SaleRequestProductTempId}"),
        // Text("IsPrinted ${product.IsPrinted}"),

        // Text("SaleRequestTempId ${product.SaleRequestTempId}"),
        // Text("ProductInternalCodeOnErp ${product.ProductInternalCodeOnErp}"),
        // Text("TotalLiquid ${product.TotalLiquid}"),
        // Text("Quantity ${product.Quantity}"),
        // Text("Value ${product.Value}"),
        // Text("PLU ${product.ProductPriceLookUpCode}"),
      ],
    );
  }
}
