import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';

class ConfirmUpdateEnterpriseDataButton extends StatelessWidget {
  const ConfirmUpdateEnterpriseDataButton({super.key});

  @override
  Widget build(BuildContext context) {
    // EnterprisePresenter enterprisePresenter =
    //     Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        onPressed: () {
          notificationDialog(
            context: context,
            titleMessage: R.string.updateEnterprise,
            content: Text(
              R.string.msgWantUpdateEnterpriseData,
              textAlign: TextAlign.center,
            ),
            onPress: () async {
              //enterprisePresenter.updateEnterpriseData(EnterpriseEntity)
              //TODO create function to update enterprise data
            },
          );
        },
        child: Text(R.string.updateEnterprise),
      ),
    );
  }
}
