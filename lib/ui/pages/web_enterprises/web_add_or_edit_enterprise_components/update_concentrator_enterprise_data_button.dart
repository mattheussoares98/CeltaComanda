import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class UpdateConcentratorEnterpriseDataButton extends StatelessWidget {
  const UpdateConcentratorEnterpriseDataButton({super.key});

  @override
  Widget build(BuildContext context) {
    EnterprisePresenter enterprisePresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: () {
          notificationDialog(
            context: context,
            titleMessage: R.string.updateConcentratorParameters,
            content:
                Text(R.string.msgWantUpdateConcentratorEnterpriseParameters),
            onPress: () async {
              await enterprisePresenter
                  .updateConcentratorEnterpriseParameters(); //TODO pass the enterprise name to update menu
            },
          );
        },
        child: Text(R.string.updateConcentratorParameters),
      ),
    );
  }
}
