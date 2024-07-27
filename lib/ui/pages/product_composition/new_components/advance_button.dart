import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        return "INSERIR NO CARRINHO";
      } else if (widget.leftSelectedIndex == 0 && !widget.productHasComment) {
        return "INSERIR NO CARRINHO";
      } else {
        return "AVANÇAR";
      }
    } else {
      if (widget.leftSelectedIndex ==
          selectedProduct.childsComposition!.length) {
        return "INSERIR NO CARRINHO";
      } else if (selectedProduct.childsComposition![widget.leftSelectedIndex]
                  .IsOptionalItem ==
              "true" &&
          selectedProduct.childsComposition![widget.leftSelectedIndex]
                  .indexOfSelectedChild ==
              null) {
        return "PULAR";
      } else {
        return "AVANÇAR";
      }
    }
  }

  bool _getCanAdvanceIndex(
    ProductCompositionPresenter productCompositionPresenter,
  ) {
    if (widget.selectedProduct.childsComposition == null) {
      return true;
    }

    ProductCompositionViewModel selectedFather =
        widget.selectedProduct.childsComposition![0];

    if (widget.leftSelectedIndex <
        widget.selectedProduct.childsComposition!.length) {
      selectedFather =
          widget.selectedProduct.childsComposition![widget.leftSelectedIndex];
    }

    return productCompositionPresenter.fatherIsValid(selectedFather);
  }

  Future<void> _addInCart({
    required CartPresenter cartPresenter,
    required double totalPrice,
    required int quantity,
    required BuildContext context,
  }) async {
    if (widget.selectedProduct.childsComposition == null) {
      //add product in cart
    } else {
      bool added = await cartPresenter.addConfirmedCombox(
        selectedChilds: widget.selectedProduct.childsComposition!
            .where((e) => e.indexOfSelectedChild != null)
            .toList(),
        totalPrice: totalPrice,
        quantity: quantity,
        selectedCombox: widget.selectedProduct,
      );
      if (added) {
        Future.delayed(Duration.zero, () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  Future<void> _advanceOrAddInCart({
    required CartPresenter cartPresenter,
    required double totalPrice,
    required int quantity,
    required BuildContext context,
    required CommentsPresenter commentsPresenter,
  }) async {
    if (widget.selectedProduct.childsComposition == null) {
      if (widget.leftSelectedIndex == 0 && widget.productHasComment) {
        widget.advanceSelectedIndex();
      } else {
        //adicionar no carrinho
      }
    } else {
      if (widget.leftSelectedIndex !=
          widget.selectedProduct.childsComposition!.length) {
        widget.advanceSelectedIndex();
      } else {
        await _addInCart(
          cartPresenter: cartPresenter,
          totalPrice: totalPrice,
          quantity: quantity,
          context: context,
        );
      }
    }
  }

  static bool canAdvanceIndex = false;

  @override
  void initState() {
    super.initState();

    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    canAdvanceIndex = _getCanAdvanceIndex(productCompositionPresenter);
  }

  @override
  Widget build(BuildContext context) {
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: canAdvanceIndex
                ? () async {
                    await _advanceOrAddInCart(
                      cartPresenter: cartPresenter,
                      totalPrice: widget.totalPrice,
                      quantity: widget.quantity,
                      context: context,
                      commentsPresenter: commentsPresenter,
                    );
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _getButtonText(
                  widget.selectedProduct,
                  commentsPresenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
