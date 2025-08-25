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
    required int? value,
    required BuildContext context,
  }) async {
    if (paymentPresenter.authorizationPendingModel?.isPending == true) {
      notificationDialog(
          context: context,
          titleMessage: R.string.msgAuthorizationIsPendant,
          content: Text(R.string.msgPendantAuthorizationNotification),
          onPress: () async {
            await paymentPresenter.updateSelectedCustomer(
              customer,
              value,
            );
          });
    } else {
      await paymentPresenter.updateSelectedCustomer(
        customer,
        value,
      );
    }

    callSetState();
  }

  @override
  Widget build(BuildContext context) {
    PaymentPresenter paymentPresenter = Provider.of(context, listen: false);

    return InkWell(
      onTap: () async {
        await _updateSelectedCovenant(
          paymentPresenter: paymentPresenter,
          value: covenant?.Code,
          context: context,
        );
      },
      child: RadioGroup<int?>(
        groupValue: paymentPresenter.selectedCustomer?.covenantCode,
        child: Row(
          children: [
            Radio(value: covenant?.Code),
            Expanded(
              child: Text(
                covenant!.Name,
                style: TextStyle(
                  fontSize: StringSize.size,
                ),
              ),
            ),
          ],
        ),
        onChanged: (value) async {
          await _updateSelectedCovenant(
            paymentPresenter: paymentPresenter,
            value: value,
            context: context,
          );
        },
      ),
    );
  }
}
