import 'package:flutter/material.dart';

void notificationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Function() onPress,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                Navigator.of(context).pop();
                await onPress();
              },
            ),
          ],
        );
      });
}
