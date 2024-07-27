import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class AdvanceButton extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final int leftSelectedIndex;
  final void Function() advanceSelectedIndex;
  final void Function() addInCart;
  const AdvanceButton({
    required this.selectedProduct,
    required this.leftSelectedIndex,
    required this.advanceSelectedIndex,
    required this.addInCart,
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

  Function getAdvanceOrAddInCartFunction() {
    if (selectedProduct.childsComposition == null && leftSelectedIndex == 0) {
      return advanceSelectedIndex;
    } else if (selectedProduct.childsComposition == null &&
        leftSelectedIndex == 1) {
      return addInCart;
    } else if (selectedProduct.childsComposition != null) {
      return addInCart;
    } else {
      return advanceSelectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    ProductCompositionPresenter productCompositionPresenter =
        Provider.of(context, listen: false);
    CommentsPresenter commentsPresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: canAdvanceIndex(productCompositionPresenter)
                ? getAdvanceOrAddInCartFunction
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
