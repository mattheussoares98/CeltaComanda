import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class InsertCustomerPage extends StatefulWidget {
  const InsertCustomerPage({super.key});

  @override
  State<InsertCustomerPage> createState() => _InsertCustomerPageState();
}

class _InsertCustomerPageState extends State<InsertCustomerPage> {
  final controller = TextEditingController();
  bool searchByPersonalizedCode = false;

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
        child: StreamBuilder<List<CustomerViewModel>?>(
            stream: printedProductsPresenter.customersStream,
            builder: (context, snapCustomers) {
              return Column(
                children: [
                  SearchCustomerField(
                    searchByPersonalizedCode: searchByPersonalizedCode,
                    controller: controller,
                  ),
                  PersonalizedCodeCheckBox(
                      searchByPersonalizedCode: searchByPersonalizedCode,
                      updateValue: (value) {
                        setState(() {
                          searchByPersonalizedCode = value ?? false;
                        });
                      }),
                  if (snapCustomers.data != null &&
                      snapCustomers.data!.isNotEmpty)
                    Expanded(
                      child: Column(
                        children: [
                          CustomersItems(customers: snapCustomers.data!),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                await printedProductsPresenter
                                    .updateCustomerInSaleRequest(homePresenter);
                              },
                              child: Text(R.string.confirm),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
      ),
    );
  }
}
