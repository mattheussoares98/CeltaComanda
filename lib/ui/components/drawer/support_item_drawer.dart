import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/helpers.dart';
import '../components.dart';

class SupportItemDrawer extends StatelessWidget {
  const SupportItemDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerItem(
      onTap: () async {
        Navigator.of(context).pop();
        notificationDialog(
          context: context,
          titleMessage: "",
          showCancelAndConfirmMessage: false,
          showLargeDialog: false,
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    Uri url = Uri.parse("tel:+55-11-3125-6767");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  label: Text(
                    R.string.call,
                    style: TextStyle(
                      fontSize: getStringSize(context),
                      color: Colors.green,
                    ),
                  ),
                  icon: const Icon(
                    Icons.phone_forwarded_rounded,
                    color: Colors.green,
                  ),
                  iconAlignment: IconAlignment.end,
                ),
                TextButton.icon(
                  onPressed: () async {
                    Uri url = Uri.parse("https://wa.me/+551131256767");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  label: Text(
                    R.string.sendMessage,
                    style: TextStyle(
                      fontSize: getStringSize(context),
                      color: Colors.green,
                    ),
                  ),
                  icon: Image.asset(
                    "lib/ui/assets/images/whats.png",
                    height: 35,
                    width: 35,
                  ),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
          ),
          onPress: () async {},
        );
      },
      name: R.string.support,
      leading: Icon(
        Icons.phone,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
