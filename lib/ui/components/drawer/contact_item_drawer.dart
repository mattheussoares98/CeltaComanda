import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../components.dart';

class ContactItemDrawer extends StatelessWidget {
  const ContactItemDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerItem(
      onTap: () async {
        Navigator.of(context).pop();
        notificationDialog(
          context: context,
          titleMessage: R.string.contactUs,
          showCancelAndConfirmMessage: false,
          showLargeDialog: false,
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: const Center(child: Text("+55 (11) 3125-6767")),
          ),
          onPress: () async {},
        );
      },
      name: R.string.contactUs,
      leading: Icon(
        Icons.phone,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
