import 'package:flutter/material.dart';

import '../../../../../domain/helpers/helpers.dart';
import '../../../../components/components.dart';
import '../../../../helpers/helpers.dart';
import '../../../pages.dart';

class TableConfigurationsButton extends StatelessWidget {
  const TableConfigurationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultButton(
        name: R.string.tableConfigurations,
        permissionName: PermissionName.configuracoesDaMesa,
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
