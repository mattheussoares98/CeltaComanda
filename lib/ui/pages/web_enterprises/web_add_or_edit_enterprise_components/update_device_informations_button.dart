import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class UpdateDeviceInformationsButton extends StatelessWidget {
  const UpdateDeviceInformationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    WebEnterprisesPresenter webEnterprisesPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: () {
          notificationDialog(
            context: context,
            titleMessage: R.string.updateDevicesData,
            content: Text(
              R.string.msgWantUpdateDeviceInformations,
              textAlign: TextAlign.center,
            ),
            onPress: () async {
              await webEnterprisesPresenter.updateDevicesData();
            },
          );
        },
        child: Text(R.string.updateDevicesData),
      ),
    );
  }
}
