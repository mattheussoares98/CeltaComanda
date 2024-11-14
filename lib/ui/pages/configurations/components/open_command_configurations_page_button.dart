import 'package:flutter/material.dart';

import '../../../../ui/components/components.dart';
import '../../../helpers/helpers.dart';
import '../../pages.dart';

class OpenCommandConfigurationsPageButton extends StatelessWidget {
  const OpenCommandConfigurationsPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        notificationDialog(
            context: context,
            titleMessage: R.string.tableConfigurations,
            showCancelAndConfirmMessage: false,
            showCloseAction: true,
            showLargeDialog: true,
            content: CommandConfigurationsPage(),
            onPress: () async {});
      },
      child: FittedBox(
        child: Text(
          R.string.tableConfigurations,
        ),
      ),
    );
  }
}
