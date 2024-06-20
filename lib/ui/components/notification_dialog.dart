import 'package:flutter/material.dart';

void notificationDialog({
  required BuildContext context,
  required String titleMessage,
  required Widget? content,
  required Future Function() onPress,
  Future Function()? onCancelPress,
  bool? closeDialogOnConfirmPress = true,
  String? cancelMessage = "NÃO",
  String? confirmMessage = "SIM",
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
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
                  onPressed: () async {
                    await onCancelPress!();

                    Future.delayed(Duration.zero, () {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    cancelMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (closeDialogOnConfirmPress == true) {
                      Navigator.of(context).pop();
                    }
                    await onPress();
                  },
                  child: Text(confirmMessage!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            )
          ],
        );
      });
}
