import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class AdvanceButton extends StatelessWidget {
  final ProductsViewModel selectedProduct;
  final int indexOfSelectedFather;
  final ScrollController scrollController;
  const AdvanceButton({
    required this.selectedProduct,
    required this.indexOfSelectedFather,
    required this.scrollController,
    super.key,
  });

  String getButtonText(
    int indexOfSelectedFather,
    ProductsViewModel selectedProduct,
    CommentsPresenter commentsPresenter,
  ) {
    if (indexOfSelectedFather == selectedProduct.childsComposition!.length) {
      return "INSERIR";
    } else if (selectedProduct
            .childsComposition![indexOfSelectedFather].IsOptionalItem ==
        "true") {
      return "PULAR";
    } else {
      return "AVANÇAR";
    }
  }

  ProductCompositionViewModel getSelectedFather(
    ProductsViewModel selectedProduct,
    int indexOfSelectedFather,
  ) {
    ProductCompositionViewModel selectedFather =
        selectedProduct.childsComposition![0];

    if (indexOfSelectedFather < selectedProduct.childsComposition!.length) {
      selectedFather =
          selectedProduct.childsComposition![indexOfSelectedFather];
    }

    return selectedFather;
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
            onPressed: productCompositionPresenter.fatherIsValid(
                    getSelectedFather(selectedProduct, indexOfSelectedFather))
                ? () {
                    productCompositionPresenter
                        .advanceFatherIndex(commentsPresenter);
                    productCompositionPresenter.scrollToIndex(scrollController);
                  }
                : null,
            child: Text(
              getButtonText(
                indexOfSelectedFather,
                selectedProduct,
                commentsPresenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
