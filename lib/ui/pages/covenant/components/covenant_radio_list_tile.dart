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
    required CovenantPresenter covenantPresenter,
    required String? value,
  }) async {
    await covenantPresenter.updateSelectedCovenant(
      customer,
      value,
    );
    callSetState();
  }

  @override
  Widget build(BuildContext context) {
    CovenantPresenter covenantPresenter = Provider.of(context, listen: false);

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
      groupValue: covenantPresenter.selectedCovenant[customer.Code],
      onChanged: (value) async {
        if (covenantPresenter.authorizationPendingModel?.isPending == true) {
          notificationDialog(
              context: context,
              titleMessage: R.string.msgAuthorizationIsPendant,
              content: Text(R.string.msgPendantAuthorizationNotification),
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
  }
}
