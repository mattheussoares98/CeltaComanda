import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class SelectedCustomer extends StatelessWidget {
  const SelectedCustomer({super.key});

  String getCustomerDescription(
    PrintedProductsPresenter printedProductsPresenter,
  ) {
    final customer = printedProductsPresenter.customerInSaleRequest;

    String value = "\n${customer?.Name}"
        "\n${R.string.code} (${customer?.Code})";

    if (customer?.Code != customer?.PersonalizedCode) {
      value += "\n${R.string.personalizedCode} (${customer?.PersonalizedCode})";
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return RichText(
      text: TextSpan(
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: StringSize.size,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
          text: R.string.selectedCustomer,
          children: [
            TextSpan(
              text: getCustomerDescription(printedProductsPresenter),
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ]),
    );
  }
}
