import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../helpers/helpers.dart';
import '../components.dart';

class ContactItemDrawer extends StatelessWidget {
  const ContactItemDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneNumber = "+55 (11) 3125-6767";

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  phoneNumber,
                  style: TextStyle(fontSize: getStringSize(context)),
                )),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: phoneNumber));
                    showAlertMessage(context, "R.string.success");
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
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
