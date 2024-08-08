import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/entities.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class AdvanceButton extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int leftSelectedIndex;
  final void Function() advanceSelectedIndex;
  final int quantity;
  final double totalPrice;
  final bool productHasComment;
  const AdvanceButton({
    required this.selectedProduct,
    required this.leftSelectedIndex,
    required this.advanceSelectedIndex,
    required this.quantity,
    required this.totalPrice,
    required this.productHasComment,
    super.key,
  });

  @override
  State<AdvanceButton> createState() => _AdvanceButtonState();
}

class _AdvanceButtonState extends State<AdvanceButton> {
  String _getButtonText(
    ProductsViewModel selectedProduct,
    CommentsPresenter commentsPresenter,
  ) {
    if (selectedProduct.childsComposition == null) {
      if (widget.leftSelectedIndex == 1) {
        return R.string.insertInCart.toUpperCase();
      } else if (widget.leftSelectedIndex == 0 && !widget.productHasComment) {
        return R.string.insertInCart.toUpperCase();
      } else {
        return R.string.advance.toUpperCase();
      }
    } else {
      if (widget.leftSelectedIndex ==
          selectedProduct.childsComposition!.length) {
        return R.string.insertInCart.toUpperCase();
      } else if (selectedProduct.childsComposition![widget.leftSelectedIndex]
                  .IsOptionalItem ==
              "true" &&
          selectedProduct.childsComposition![widget.leftSelectedIndex]
                  .indexOfSelectedChild ==
              null) {
        return R.string.jump.toUpperCase();
      } else {
        return R.string.advance.toUpperCase();
      }
    }
  }

  void updateSelectedCommentsOfChildsComposition(
      CommentsPresenter commentsPresenter) {
    if (widget.selectedProduct.childsComposition != null) {
      for (var child in widget.selectedProduct.childsComposition!) {
        if (commentsPresenter.productHasComment(
          internalCodeOnERP: child.InternalCodeOnERPCodeChild!.toInt(),
          productName: child.ChildName!,
        )) {
          child.commentFather =
              commentsPresenter.getConcatenateSelectedComments(
                  child.InternalCodeOnERPCodeChild!.toInt());
        }
      }
    }
  }

  Future<void> _addInCart({
    required CartPresenter cartPresenter,
    required double totalPrice,
    required BuildContext context,
    required InsertProductPresenter insertProductsPresenter,
    required MenuPresenter menuPresenter,
    required CommentsPresenter commentsPresenter,
  }) async {
    updateSelectedCommentsOfChildsComposition(commentsPresenter);

    await cartPresenter.addProductInCart(
      product: CartProductEntity(
        Product: widget.selectedProduct.toEntityWithSelectedChilds(
            insertProductsPresenter.totalProductsQuantity),
        Comments: commentsPresenter.getConcatenateSelectedComments(
            widget.selectedProduct.InternalCodeOnERP!.toInt()),
        TotalLiquid: widget.selectedProduct.SaleRetailPraticed.toDouble() *
            insertProductsPresenter.totalProductsQuantity,
        Quantity: insertProductsPresenter.totalProductsQuantity.toDouble(),
        Value: widget.selectedProduct.SaleRetailPraticed.toDouble(),
        ProductPriceLookUpCode: widget.selectedProduct.PriceLookupCode,
      ),
      menuPresenter: menuPresenter,
      commentsPresenter: commentsPresenter,
    );
    Future.delayed(Duration.zero, () {
      Navigator.of(context).popUntil((route) => route.isFirst);
      AnimatedAlertDialog.open(
        context: context,
        page: const CartPage(),
      );
    });
  }

  Future<void> _advanceOrAddInCart({
    required CartPresenter cartPresenter,
    required double totalPrice,
    required int quantity,
    required BuildContext context,
    required CommentsPresenter commentsPresenter,
    required InsertProductPresenter insertProductsPresenter,
    required MenuPresenter menuPresenter,
  }) async {
    if (widget.selectedProduct.childsComposition == null) {
      if (widget.leftSelectedIndex == 0 && widget.productHasComment) {
        widget.advanceSelectedIndex();
      } else {
        await _addInCart(
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          commentsPresenter: commentsPresenter,
          insertProductsPresenter: insertProductsPresenter,
          totalPrice: totalPrice,
          context: context,
        );
      }
    } else {
      if (widget.leftSelectedIndex !=
          widget.selectedProduct.childsComposition!.length) {
        widget.advanceSelectedIndex();
      } else {
        await _addInCart(
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          commentsPresenter: commentsPresenter,
          insertProductsPresenter: insertProductsPresenter,
          totalPrice: totalPrice,
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: insertProductsPresenter.canAdvanceIndex
            ? Theme.of(context).secondaryHeaderColor
            : Theme.of(context).primaryColorDark,
      ),
      onPressed: insertProductsPresenter.canAdvanceIndex
          ? () async {
              await _advanceOrAddInCart(
                cartPresenter: cartPresenter,
                totalPrice: widget.totalPrice,
                quantity: widget.quantity,
                context: context,
                commentsPresenter: commentsPresenter,
                insertProductsPresenter: insertProductsPresenter,
                menuPresenter: menuPresenter,
              );
            }
          : null,
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              _getButtonText(
                widget.selectedProduct,
                commentsPresenter,
              ),
              style: TextStyle(
                fontSize: getStringSize(context),
              )),
        ),
      ),
    );
  }
}
