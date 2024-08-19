import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/entities.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../components/components.dart';
import '../../pages.dart';

class AdvanceButton extends StatefulWidget {
  final ProductsViewModel selectedProduct;
  final int leftSelectedIndex;
  final int quantity;
  final double totalPrice;
  final SelectedOptionType? atualOption;
  const AdvanceButton({
    required this.selectedProduct,
    required this.leftSelectedIndex,
    required this.quantity,
    required this.totalPrice,
    required this.atualOption,
    super.key,
  });

  @override
  State<AdvanceButton> createState() => _AdvanceButtonState();
}

class _AdvanceButtonState extends State<AdvanceButton> {
  String _getButtonText() {
    if (widget.atualOption == SelectedOptionType.quantity) {
      return R.string.insertInCart.toUpperCase();
    } else {
      return R.string.advance.toUpperCase();
    }
  }

  void updateSelectedCommentsOfChildsComposition(
      ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter) {
    if (widget.selectedProduct.childsComposition != null) {
      for (int index = 0;
          index < widget.selectedProduct.childsComposition!.length;
          index++) {
        final child = widget.selectedProduct.childsComposition![index];

        if (expansibleGroupFromProductPresenter.productHasComment(
            product: widget.selectedProduct, indexOfChild: index)) {
          child.commentFather = expansibleGroupFromProductPresenter
              .getConcatenateSelectedCommentsAndObligatoryOptions(
                  child.InternalCodeOnERPCodeChild!.toInt());
        }
      }
    }
  }

  Future<void> _addInCart({
    required CartPresenter cartPresenter,
    required BuildContext context,
    required InsertProductPresenter insertProductsPresenter,
    required MenuPresenter menuPresenter,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
  }) async {
    updateSelectedCommentsOfChildsComposition(
        expansibleGroupFromProductPresenter);

    await cartPresenter.addProductInCart(
      product: CartProductEntity(
        Product: widget.selectedProduct.toEntityWithSelectedChilds(
            insertProductsPresenter.totalProductsQuantity),
        Comments: expansibleGroupFromProductPresenter
            .getConcatenateSelectedCommentsAndObligatoryOptions(
                widget.selectedProduct.InternalCodeOnERP!.toInt()),
        TotalLiquid: widget.selectedProduct.SaleRetailPraticed.toDouble() *
            insertProductsPresenter.totalProductsQuantity,
        Quantity: insertProductsPresenter.totalProductsQuantity.toDouble(),
        Value: widget.selectedProduct.SaleRetailPraticed.toDouble(),
        ProductPriceLookUpCode: widget.selectedProduct.PriceLookupCode,
      ),
      menuPresenter: menuPresenter,
      expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
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
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required InsertProductPresenter insertProductsPresenter,
    required MenuPresenter menuPresenter,
  }) async {
    final productHasComment =
        expansibleGroupFromProductPresenter.productHasComment(
      product: widget.selectedProduct,
      indexOfChild: 0,
    );

    final productHasObligatoryOptions =
        expansibleGroupFromProductPresenter.productHasObligatoryOption(
      product: widget.selectedProduct,
      indexOfChild: 0,
    );
    if (widget.selectedProduct.childsComposition == null) {
      if (widget.leftSelectedIndex == 0 && productHasComment) {
        insertProductsPresenter
            .advanceFatherIndex(expansibleGroupFromProductPresenter);
      } else if (widget.leftSelectedIndex == 0 && productHasObligatoryOptions) {
        insertProductsPresenter
            .advanceFatherIndex(expansibleGroupFromProductPresenter);
      } else if (widget.leftSelectedIndex == 1 && productHasObligatoryOptions) {
        insertProductsPresenter
            .advanceFatherIndex(expansibleGroupFromProductPresenter);
      } else {
        await _addInCart(
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          insertProductsPresenter: insertProductsPresenter,
          context: context,
        );
      }
    } else {
      if (widget.atualOption == SelectedOptionType.quantity) {
        await _addInCart(
          cartPresenter: cartPresenter,
          menuPresenter: menuPresenter,
          expansibleGroupFromProductPresenter:
              expansibleGroupFromProductPresenter,
          insertProductsPresenter: insertProductsPresenter,
          context: context,
        );
      } else {
        insertProductsPresenter
            .advanceFatherIndex(expansibleGroupFromProductPresenter);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ExpansibleGroupFromProductPresenter expansibleGroupFromProductPresenter =
        Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);
    MenuPresenter menuPresenter = Provider.of(context, listen: false);
    InsertProductPresenter insertProductsPresenter =
        Provider.of(context, listen: false);

    return StreamBuilder<bool>(
        stream: insertProductsPresenter.canAdvanceIndexStream,
        builder: (context, snapshot) {
          insertProductsPresenter
              .updateCanAdvanceIndex(expansibleGroupFromProductPresenter);

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: snapshot.data == true
                  ? Theme.of(context).secondaryHeaderColor
                  : Theme.of(context).primaryColorDark,
            ),
            onPressed: snapshot.data == true
                ? () async {
                    await _advanceOrAddInCart(
                      cartPresenter: cartPresenter,
                      totalPrice: widget.totalPrice,
                      quantity: widget.quantity,
                      context: context,
                      expansibleGroupFromProductPresenter:
                          expansibleGroupFromProductPresenter,
                      insertProductsPresenter: insertProductsPresenter,
                      menuPresenter: menuPresenter,
                    );
                  }
                : null,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_getButtonText(),
                    style: TextStyle(
                      fontSize: getStringSize(context),
                    )),
              ),
            ),
          );
        });
  }
}
