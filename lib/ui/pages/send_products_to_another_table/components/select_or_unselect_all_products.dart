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

  @override
  Widget build(BuildContext context) {
    SendProductsToAnotherTablePresenter sendProductsToAnotherTablePresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        if (printedViewModel?.Products.length ==
            sendProductsToAnotherTablePresenter
                .selectedsSaleRequestProductsIds.length) {
          sendProductsToAnotherTablePresenter
              .clearAllSelectedsSaleRequestProductsIds();
          callSetState();
        } else {
          sendProductsToAnotherTablePresenter.selectAllProducts();

          callSetState();
        }
      },
      child: Text(
        printedViewModel?.Products.length ==
                sendProductsToAnotherTablePresenter
                    .selectedsSaleRequestProductsIds.length
            ? R.string.unselectAllProducts
            : R.string.selectAllProducts,
      ),
    );
  }
}
