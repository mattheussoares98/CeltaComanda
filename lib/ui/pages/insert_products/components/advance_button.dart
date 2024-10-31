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
  final InsertProductsViewModel insertProductsViewModel;
  const AdvanceButton({
    required this.selectedProduct,
    required this.leftSelectedIndex,
    required this.quantity,
    required this.totalPrice,
    required this.atualOption,
    required this.insertProductsViewModel,
    super.key,
  });

  @override
  State<AdvanceButton> createState() => _AdvanceButtonState();
}

class _AdvanceButtonState extends State<AdvanceButton> {
  String _getButtonText() {
    if (widget.atualOption == SelectedOptionType.quantity) {
      return R.string.insertInCart.toUpperCase();
    } else if (widget.atualOption ==
        SelectedOptionType.optionalExpansibleGroup) {
      final teste = widget.insertProductsViewModel.selectedOptions.values.first;
      final selectedLength = teste.where((e) => e.selected == true).length;
      if (selectedLength > 0) {
        return R.string.advance;
      } else {
        return R.string.jump;
      }
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
        TotalLiquid: widget.totalPrice,
        Quantity: insertProductsPresenter.totalProductsQuantity.toDouble(),
        Value: widget.totalPrice /
            insertProductsPresenter.totalProductsQuantity.toDouble(),
        ProductPriceLookUpCode: widget.selectedProduct.PriceLookupCode,
      ),
      menuPresenter: menuPresenter,
      expansibleGroupFromProductPresenter: expansibleGroupFromProductPresenter,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Navigator.of(context).popUntil((route) => route.isFirst);
      PersonalizedDialogPage.open(
        context: context,
        page: const CartPage(),
      );
    });
    menuPresenter.advanceIndexOfAtualSuggestion();
  }

  Future<void> _advanceOrAddInCart({
    required CartPresenter cartPresenter,
    required BuildContext context,
    required ExpansibleGroupFromProductPresenter
        expansibleGroupFromProductPresenter,
    required InsertProductPresenter insertProductsPresenter,
    required MenuPresenter menuPresenter,
  }) async {
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
          .advanceOptionIndex(expansibleGroupFromProductPresenter);
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
          Future.delayed(Duration.zero, () {
            insertProductsPresenter
                .updateCanAdvanceIndex(expansibleGroupFromProductPresenter);
          });

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
