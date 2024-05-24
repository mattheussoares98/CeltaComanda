import 'package:flutter/material.dart';

void showAlertMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(message, textAlign: TextAlign.center),
  ));
}
