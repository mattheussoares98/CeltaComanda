import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class RemoveCustomerButton extends StatelessWidget {
  const RemoveCustomerButton({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      onPressed: () {
        notificationDialog(
            context: context,
            titleMessage: R.string.removeCustomer,
            content: null,
            onPress: () async {
              await printedProductsPresenter.updateCustomerInSaleRequest(
                  homePresenter,
                  isRemoving: true);
            });
      },
      child: Text(R.string.removeCustomer),
    );
  }
}
