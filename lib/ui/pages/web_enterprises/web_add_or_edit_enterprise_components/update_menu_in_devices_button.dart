import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class UpdateMenuInDevicesButton extends StatelessWidget {
  const UpdateMenuInDevicesButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ElevatedButton(
        onPressed: () {
          notificationDialog(
            context: context,
            titleMessage: R.string.updateMenu,
            content: Text(R.string.msgWantUpdateMenuInAllDevices),
            onPress: () async {
              await configurationsPresenter
                  .loadMenuAgain(); //TODO pass the enterprise name to update menu
            },
          );
        },
        child: Text(R.string.updateMenu),
      ),
    );
  }
}
