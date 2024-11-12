import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class UpdateMenuButton extends StatelessWidget {
  const UpdateMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigurationsPresenter configurationsPresenter =
        Provider.of(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        notificationDialog(
            context: context,
            titleMessage: R.string.updateMenu,
            content: Text(R.string.msgWantUpdateMenuInAllDevices),
            onPress: () async {
              final updated = await configurationsPresenter.loadMenuAgain();

              if (updated) {
                snackBarMessage(
                    // ignore: use_build_context_synchronously
                    context,
                    R.string.msgSuccessUpdateMenuInAllDevices);
              }
            });
      },
      child: Text(
        R.string.updateMenu,
      ),
    );
  }
}
