import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class ConfirmUpdateCustomerButton extends StatelessWidget {
  const ConfirmUpdateCustomerButton({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          bool updated = await printedProductsPresenter
              .updateCustomerInSaleRequest(homePresenter);

          if (updated) {
            Navigator.of(context).pop();
          }
        },
        child: Text(R.string.confirm),
      ),
    );
  }
}
