import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class InsertCustomer extends StatelessWidget {
  const InsertCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: GetCustomerField(
          //TODO move to components
          searchCustomerController: TextEditingController(),
          errorText: "", //TODO create a stream to control the error
          searchByPersonalizedCode: false, //treat this
          customers: [],
        ),
      ),
    );
  }
}
