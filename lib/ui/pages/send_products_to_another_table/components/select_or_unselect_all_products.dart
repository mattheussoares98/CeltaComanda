import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../pages.dart';

class SelectOrUnselectAllProducts extends StatelessWidget {
  final PrintedViewModel? printedViewModel;
  final void Function() callSetState;
  const SelectOrUnselectAllProducts({
    required this.printedViewModel,
    required this.callSetState,
    super.key,
  });

  bool allProductsAreSelected(
      SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter) {
    if (printedViewModel == null) {
      return false;
    }

    return printedViewModel?.Products.length ==
        sendProductsToAnotherTablePresenter
            .selectedsSaleRequestProductsIds.length;
  }

  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        if (allProductsAreSelected(sendProductsToAnotherTablePresenter)) {
          sendProductsToAnotherTablePresenter
              .clearAllSelectedsSaleRequestProductsIds();
          callSetState();
        } else {
          sendProductsToAnotherTablePresenter.selectAllProducts();

          callSetState();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          allProductsAreSelected(sendProductsToAnotherTablePresenter)
              ? R.string.unselectAll
              : R.string.selectAll,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
