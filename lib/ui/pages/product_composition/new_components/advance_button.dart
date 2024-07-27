import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class AdvanceButton extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  final void Function() advanceSelectedIndex;
  const AdvanceButton({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    required this.advanceSelectedIndex,
    super.key,
  });

  String getButtonText(
    int indexOfSelectedFather,
    ProductsViewModel selectedProduct,
    CommentsPresenter commentsPresenter,
  ) {
    if (indexOfSelectedFather == selectedProduct.childsComposition!.length) {
      return "INSERIR NO CARRINHO";
    } else if (selectedProduct
            .childsComposition![indexOfSelectedFather].IsOptionalItem ==
        "true") {
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

    if (indexOfSelectedFather < selectedProduct.childsComposition!.length) {
      selectedFather =
          selectedProduct.childsComposition![indexOfSelectedFather];
    }

    return productCompositionPresenter.fatherIsValid(selectedFather);
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
                ? advanceSelectedIndex
                : null,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                getButtonText(
                  indexOfSelectedFather,
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
