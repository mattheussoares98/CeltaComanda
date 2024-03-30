import '../helpers/helpers.dart';

import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  // Future.delayed(Duration.zero);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SimpleDialog(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(R.string.wait, textAlign: TextAlign.center),
          ],
        ),
      ],
    ),
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
