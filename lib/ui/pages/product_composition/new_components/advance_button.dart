import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class AdvanceButton extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final int leftSelectedIndex;
  final void Function() advanceSelectedIndex;
  final int quantity;
  final double totalPrice;
  const AdvanceButton({
    required this.selectedProduct,
    required this.leftSelectedIndex,
    required this.advanceSelectedIndex,
    required this.quantity,
    required this.totalPrice,
    super.key,
  });

  String getButtonText(
    ProductsViewModel selectedProduct,
    CommentsPresenter commentsPresenter,
  ) {
    if (selectedProduct.childsComposition == null && leftSelectedIndex == 0) {
      return "AVANÇAR";
    } else if (selectedProduct.childsComposition == null &&
        leftSelectedIndex == 1) {
      return "INSERIR NO CARRINHO";
    } else if (leftSelectedIndex == selectedProduct.childsComposition!.length) {
      return "INSERIR NO CARRINHO";
    } else if (selectedProduct
                .childsComposition![leftSelectedIndex].IsOptionalItem ==
            "true" &&
        selectedProduct
                .childsComposition![leftSelectedIndex].indexOfSelectedChild ==
            null) {
      return "PULAR";
    } else {
      return "AVANÇAR";
    }
  }

  bool canAdvanceIndex(
    ProductCompositionPresenter productCompositionPresenter,
  ) {
    if (selectedProduct.childsComposition == null) {
      return true;
    }

    ProductCompositionViewModel selectedFather =
        selectedProduct.childsComposition![0];

    if (leftSelectedIndex < selectedProduct.childsComposition!.length) {
      selectedFather = selectedProduct.childsComposition![leftSelectedIndex];
    }

    return productCompositionPresenter.fatherIsValid(selectedFather);
  }

  advanceOrAddInCart({
    required CartPresenter cartPresenter,
    required double totalPrice,
    required int quantity,
  }) async {
    if (selectedProduct.childsComposition == null && leftSelectedIndex == 0) {
      advanceSelectedIndex();
    } else if (selectedProduct.childsComposition == null &&
        leftSelectedIndex == 1) {
      //adicionar produto no carrinho
    } else if (selectedProduct.childsComposition != null &&
        leftSelectedIndex == selectedProduct.childsComposition!.length) {
      await cartPresenter.addConfirmedCombox(
        selectedChilds: selectedProduct.childsComposition!
            .where((e) => e.indexOfSelectedChild != null)
            .toList(),
        totalPrice: totalPrice,
        quantity: quantity,
        selectedCombox: selectedProduct,
      );
    } else {
      advanceSelectedIndex();
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);
    CartPresenter cartPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: canAdvanceIndex(productCompositionPresenter)
                ? () {
                    advanceOrAddInCart(
                      cartPresenter: cartPresenter,
                      totalPrice: totalPrice,
                      quantity: quantity,
                    );
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                getButtonText(
                  selectedProduct,
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
