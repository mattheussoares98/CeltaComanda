import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../pages/pages.dart';
import '../components.dart';

class TableConfigurationsItemDrawer extends StatelessWidget {
  const TableConfigurationsItemDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerItem(
      onTap: () async {
        Navigator.of(context).pop();
        notificationDialog(
          context: context,
          titleMessage: R.string.accessConfigurations,
          content: ConfigurationsDialogPage(),
          showCancelAndConfirmMessage: false,
          onPress: () async {},
        );
      },
      name: R.string.configurations,
      leading: Icon(
        Icons.settings,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
