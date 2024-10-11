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
  final passwordKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

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
  dispose() {
    super.dispose();

    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CovenantPresenter covenantPresenter = Provider.of(context, listen: false);

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
                      titleMessage: R.string.msgAuthorizationIsPendant,
                      content:
                          Text(R.string.msgPendantAuthorizationNotification),
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
        ConfirmPayment(
          customer: widget.customer,
          passwordController: passwordController,
          passwordKey: passwordKey,
        ),
      ],
    );
  }
}
