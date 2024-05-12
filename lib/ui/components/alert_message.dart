import 'package:flutter/material.dart';

void showAlertMessage(BuildContext context, String error) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(error, textAlign: TextAlign.center),
  ));
}
