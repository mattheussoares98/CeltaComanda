import 'package:flutter/material.dart';

ElevatedButton defaultButton({
  required BuildContext context,
  required String name,
  required Function() function,
}) =>
    ElevatedButton(
      onPressed: function,
      child: Text(
        name,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(),
      ),
    );
