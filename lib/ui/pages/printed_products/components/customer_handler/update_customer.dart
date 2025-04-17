import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages.dart';

class UpdateCustomer extends StatelessWidget {
  const UpdateCustomer({super.key});

  BoxDecoration containerDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).primaryColorLight,
          blurRadius: 10,
        )
      ],
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: Border.all(
        color: Theme.of(context).primaryColorLight.withAlpha(30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Container(
      decoration: containerDecoration(context),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (printedProductsPresenter.customerInSaleRequest != null)
            Expanded(flex: 3, child: FittedBox(child: SelectedCustomer())),
          Expanded(child: OpenInsertCustomerPageButton()),
          if (printedProductsPresenter.customerInSaleRequest != null)
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: RemoveCustomerButton(),
            )),
        ],
      ),
    );
  }
}
