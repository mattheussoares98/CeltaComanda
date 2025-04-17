import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class OpenInsertCustomerPageButton extends StatelessWidget {
  const OpenInsertCustomerPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        PersonalizedDialogPage.open(
          context: context,
          page: InsertCustomerPage(),
        );
      },
      child: Text(
        printedProductsPresenter.customerInSaleRequest == null
            ? R.string.addCustomer
            : R.string.changeCustomer,
      ),
    );
  }
}
