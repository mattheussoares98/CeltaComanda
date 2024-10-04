import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/helpers.dart';
import '../../pages.dart';

class Customers extends StatefulWidget {
  final TextEditingController textController;
  const Customers({
    required this.textController,
    super.key,
  });

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  Widget build(BuildContext context) {
    CovenantPresenter covenantPresenter = Provider.of(context, listen: false);

    return StreamBuilder<List<CustomerViewModel>?>(
        stream: covenantPresenter.customersViewModelStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final customer = snapshot.data![index];
                Future.delayed(Duration.zero, () {
                  widget.textController.clear();
                });
                return Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 218, 218)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${R.string.code}: ${customer.Code}",
                                style: TextStyle(
                                  fontSize: getStringSize(context),
                                ),
                              ),
                              if (customer.CpfCnpjNumber!.length >= 11)
                                Text(
                                  'CPF/CNPJ: ${customer.CpfCnpjNumber!.substring(0, 4)}...${customer.CpfCnpjNumber!.substring(customer.CpfCnpjNumber!.length - 4)}',
                                  style: TextStyle(
                                    fontSize: getStringSize(context),
                                  ),
                                ),
                              if (customer.CpfCnpjNumber!.length < 11)
                                Text(
                                  'CPF/CNPJ: ${customer.CpfCnpjNumber}',
                                  style: TextStyle(
                                    fontSize: getStringSize(context),
                                  ),
                                ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              customer.Name!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: getStringSize(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${R.string.personalizedCode}: ${customer.PersonalizedCode}",
                            style: TextStyle(
                              fontSize: getStringSize(context),
                            ),
                          ),
                          if (customer.Covenants == null ||
                              customer.Covenants!.isEmpty)
                            Expanded(
                              child: Text(
                                R.string.withoutCovenant.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: getStringSize(context),
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (customer.Covenants != null &&
                          customer.Covenants!.isNotEmpty)
                        Covenants(
                          customer: customer,
                          callSetState: () {
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                );
              });
        });
  }
}
