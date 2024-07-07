import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

void showAlertMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(NavigatorKey.navigatorKey.currentContext ?? context)
      .clearSnackBars();
  ScaffoldMessenger.of(NavigatorKey.navigatorKey.currentContext ?? context)
      .showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize:
              hasMinWidth(NavigatorKey.navigatorKey.currentContext ?? context)
                  ? 25
                  : 17,
        ),
      ),
      dismissDirection: DismissDirection.down,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      showCloseIcon: true,
      closeIconColor: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
