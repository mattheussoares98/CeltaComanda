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
        PersonalizedDialogPage.open(
          context: context,
          page: const TableConfigurationsPage(),
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
