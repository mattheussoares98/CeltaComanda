import 'package:clean_celta_mobile/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';

class Customers extends StatelessWidget {
  final CovenantPresenter covenantPresenter;
  const Customers({
    required this.covenantPresenter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                                "Code: ${customer.Code}",
                              ),
                              Text(
                                  "PersonalizedCode: ${customer.PersonalizedCode}"),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              customer.Name,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Text(
                          'CPF/CNPJ ${customer.CpfCnpjNumber.substring(0, 4)}...${customer.CpfCnpjNumber.substring(customer.CpfCnpjNumber.length - 4)}'),
                      if (customer.Covenants.isNotEmpty)
                        Text(customer.Covenants.toString()),
                      if (customer.Covenants.isEmpty)
                        Text(
                          "SEM CONVÊNIO ADICIONAR HELPER",
                          style: TextStyle(
                            fontSize: getStringSize(context),
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                );
              });
        });
  }
}
