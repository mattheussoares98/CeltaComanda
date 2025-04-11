import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class InsertCustomer extends StatefulWidget {
  const InsertCustomer({super.key});

  @override
  State<InsertCustomer> createState() => _InsertCustomerState();
}

class _InsertCustomerState extends State<InsertCustomer> {
  final controller = TextEditingController();
  bool searchByPersonalizedCode = false;

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  Future<void> loadCustomers(
    PrintedProductsPresenter printedProductsPresenter,
  ) async {
    await printedProductsPresenter.getCustomers(
      value: controller.text,
      showErrorMessageReturnedByBs: (error) {
        snackBarMessage(context, error);
      },
      searchByPersonalizedCode: searchByPersonalizedCode,
    );
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: StreamBuilder<List<CustomerViewModel>?>(
            stream: printedProductsPresenter.customersStream,
            builder: (context, snapCustomers) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      decoration: formFieldDecoration(
                        errorText: null,
                        context: context,
                        hintText: searchByPersonalizedCode
                            ? R.string.personalizedCode
                            : R.string.internalcodeNameOrCpf,
                        labelText: searchByPersonalizedCode
                            ? R.string.personalizedCode
                            : R.string.internalcodeNameOrCpf,
                        suffixIcon: IconButton(
                          onPressed: () async {
                            loadCustomers(printedProductsPresenter);
                          },
                          icon: Icon(Icons.search,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: controller,
                      onFieldSubmitted: (_) async {
                        loadCustomers(printedProductsPresenter);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CheckboxMenuButton(
                        value: searchByPersonalizedCode,
                        onChanged: (value) {
                          setState(() {
                            searchByPersonalizedCode = value!;
                          });
                        },
                        child: Text(R.string.searchByPersonalizedCode),
                      ),
                    ),
                    if (snapCustomers.data != null &&
                        snapCustomers.data!.isNotEmpty)
                      Column(
                        children: [
                          ListView.builder(
                            itemCount: snapCustomers.data!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final customer = snapCustomers.data![index];

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
                                  value: printedProductsPresenter
                                          .selectedCustomer ==
                                      customer, //TODO fix the value
                                  onChanged: (value) {
                                    setState(() {
                                      printedProductsPresenter
                                          .updateSelectedCustomer(customer);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("${customer.Name}"),
                                        Text(
                                            "${R.string.code}: ${customer.Code}"),
                                        Text(
                                            "${R.string.cpfCnpj}: ${customer.CpfCnpjNumber}"),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(R.string.confirm),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
