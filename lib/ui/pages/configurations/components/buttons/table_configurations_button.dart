import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class TableConfigurationsButton extends StatelessWidget {
  const TableConfigurationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return defaultButton(
        context: context,
        name: R.string.tableConfigurations,
        function: () async {
          notificationDialog(
              context: context,
              titleMessage: R.string.tableConfigurations,
              showCancelAndConfirmMessage: false,
              showCloseAction: true,
              showLargeDialog: true,
              content: CommandConfigurationsPage(),
              onPress: () async {});
        });
  }
}
