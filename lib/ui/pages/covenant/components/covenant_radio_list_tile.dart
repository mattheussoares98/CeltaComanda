import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/models.dart';
import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class CovenantRadioListTile extends StatelessWidget {
  final CustomerViewModel customer;
  final void Function() callSetState;
  final CovenantModel? covenant;
  const CovenantRadioListTile({
    required this.customer,
    required this.callSetState,
    required this.covenant,
    super.key,
  });

  Future<void> _updateSelectedCovenant({
    required PaymentPresenter paymentPresenter,
    required String? value,
  }) async {
    await paymentPresenter.updateSelectedCovenant(
      customer,
      value,
    );
    callSetState();
  }

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);

    return RadioListTile<String>(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(
        covenant!.Name,
        style: TextStyle(
          fontSize: getStringSize(context),
        ),
      ),
      value: covenant!.Code.toString(),
      groupValue: paymentPresenter.selectedCovenant[customer.Code],
      onChanged: (value) async {
        if (paymentPresenter.authorizationPendingModel?.isPending == true) {
          notificationDialog(
              context: context,
              titleMessage: R.string.msgAuthorizationIsPendant,
              content: Text(R.string.msgPendantAuthorizationNotification),
              onPress: () async {
                await _updateSelectedCovenant(
                  paymentPresenter: paymentPresenter,
                  value: value,
                );
              });
        } else {
          await _updateSelectedCovenant(
            paymentPresenter: paymentPresenter,
            value: value,
          );
        }
      },
    );
  }
}
