import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Covenants extends StatelessWidget {
  final CustomerViewModel customer;
  final void Function() callSetState;
  const Covenants({
    required this.customer,
    required this.callSetState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CovenantPresenter covenantPresenter = Provider.of(context, listen: false);
    HomePresenter homePresenter = Provider.of(context, listen: false);
    PrintedProductsPresenter printedProductsPresenter =
        Provider.of(context, listen: false);

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(
                thickness: 0.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                R.string.covenants,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: getStringSize(context),
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                thickness: 0.2,
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: customer.Covenants.length,
          itemBuilder: (context, index) {
            final covenant = customer.Covenants[index];

            return RadioListTile<String>(
              dense: true,
              visualDensity: VisualDensity.compact,
              title: Text(
                covenant.Name,
                style: TextStyle(
                  fontSize: getStringSize(context),
                ),
              ),
              value: covenant.Code.toString(),
              groupValue: covenantPresenter.selectedCovenant[customer.Code],
              onChanged: (value) {
                covenantPresenter.updateSelectedCovenant(customer, value);
                callSetState();
              },
            );
          },
        ),
        ElevatedButton(
          onPressed: covenantPresenter.selectedCovenant
                  .containsKey(customer.Code)
              ? () async {
                  await covenantPresenter.finishSaleRequestByCovenant(
                    homePresenter: homePresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    showErrorMessageReturnedByBs: (error) {
                      showAlertMessage(
                        context,
                        error,
                        backgroundColor: Colors.red,
                      );
                    },
                    closePagesUntilHomePage: () {
                      Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      );
                      showAlertMessage(
                        context,
                        R.string.liquidateCommandSucceeds,
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                      );
                    },
                  );
                }
              : null,
          child: Text(
            R.string.liquidateCommand.toUpperCase(),
          ),
        ),
      ],
    );
  }
}
