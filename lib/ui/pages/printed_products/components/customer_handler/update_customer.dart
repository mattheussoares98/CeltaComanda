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

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
        decoration: containerDecoration(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (printedProductsPresenter.customerInSaleRequest != null)
                SelectedCustomer(),
              OpenInsertCustomerPageButton(),
              if (printedProductsPresenter.customerInSaleRequest != null)
                RemoveCustomerButton(),
            ],
          ),
        ),
      ),
    );
  }
}
