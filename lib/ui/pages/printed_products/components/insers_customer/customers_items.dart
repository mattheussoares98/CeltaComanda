import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class CustomersItems extends StatefulWidget {
  final List<CustomerViewModel> customers;
  const CustomersItems({super.key, required this.customers});

  @override
  State<CustomersItems> createState() => _CustomersItemsState();
}

class _CustomersItemsState extends State<CustomersItems> {
  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Expanded(
      child: ListView.builder(
        itemCount: widget.customers.length,
        itemBuilder: (context, index) {
          final customer = widget.customers[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: CheckboxMenuButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context)
                      .primaryColorLight
                      .withAlpha(index % 2 == 0 ? 10 : 30),
                ),
              ),
              value: printedProductsPresenter.selectedCustomer == customer,
              onChanged: (value) {
                setState(() {
                  printedProductsPresenter.updateSelectedCustomer(customer);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${customer.Name}"),
                    Text("${R.string.code}: ${customer.Code}"),
                    if(customer.PersonalizedCode != null)
                    Text("${R.string.personalizedCode}: ${customer.PersonalizedCode}"),
                    Text("${R.string.cpfCnpj}: ${customer.CpfCnpjNumber}"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
