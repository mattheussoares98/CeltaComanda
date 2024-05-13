import 'package:flutter/material.dart';

void notificationDialog({
  required BuildContext context,
  required String titleMessage,
  required Widget? content,
  required Future Function() onPress,
  String? cancelMessage = "NÃO",
  String? confirmMessage = "SIM",
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titleMessage,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: content,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    cancelMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await onPress();
                  },
                  child: Text(confirmMessage!),
                ),
              ],
            )
          ],
        );
      });
}
