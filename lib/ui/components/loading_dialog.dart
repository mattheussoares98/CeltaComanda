import '../helpers/helpers.dart';

import 'package:flutter/material.dart';

import 'loading_image.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SimpleDialog(
      surfaceTintColor: Colors.white,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: loadingImage(),
            ),
            const SizedBox(height: 10),
            const LinearProgressIndicator(),
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
