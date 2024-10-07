// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class Covenants extends StatefulWidget {
  final CustomerViewModel customer;
  final void Function() callSetState;
  const Covenants({
    required this.customer,
    required this.callSetState,
    super.key,
  });

  @override
  State<Covenants> createState() => _CovenantsState();
}

class _CovenantsState extends State<Covenants> {
  Future<void> _finishSaleRequestByCovenant({
    required CovenantPresenter covenantPresenter,
    required HomePresenter homePresenter,
    required PrintedProductsPresenter printedProductsPresenter,
    required BuildContext context,
  }) async {
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

  Future<void> _updateSelectedCovenant({
    required CovenantPresenter covenantPresenter,
    required String? value,
  }) async {
    await covenantPresenter.updateSelectedCovenant(
      widget.customer,
      value,
    );
    widget.callSetState();
  }

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
          itemCount: widget.customer.Covenants?.length,
          itemBuilder: (context, index) {
            final covenant = widget.customer.Covenants?[index];

            return RadioListTile<String>(
              dense: true,
              visualDensity: VisualDensity.compact,
              title: Text(
                covenant!.Name,
                style: TextStyle(
                  fontSize: getStringSize(context),
                ),
              ),
              value: covenant.Code.toString(),
              groupValue:
                  covenantPresenter.selectedCovenant[widget.customer.Code],
              onChanged: (value) async {
                if (covenantPresenter.authorizationPendingModel?.isPending ==
                    true) {
                  notificationDialog(
                      context: context,
                      titleMessage: "Pendant helper",
                      content: const Text(
                          "Add helper with message indicating that authorization is pendant"),
                      onPress: () async {
                        await _updateSelectedCovenant(
                          covenantPresenter: covenantPresenter,
                          value: value,
                        );
                      });
                } else {
                  await _updateSelectedCovenant(
                    covenantPresenter: covenantPresenter,
                    value: value,
                  );
                }
              },
            );
          },
        ),
        ElevatedButton(
          onPressed: covenantPresenter.selectedCovenant
                  .containsKey(widget.customer.Code)
              ? () async {
                  await _finishSaleRequestByCovenant(
                    covenantPresenter: covenantPresenter,
                    homePresenter: homePresenter,
                    printedProductsPresenter: printedProductsPresenter,
                    context: context,
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
