import 'dart:async';

import '../components/components.dart';

import 'package:flutter/material.dart';

mixin LoadingManager {
  // static bool isDialogShowing = false;
  StreamSubscription handleLoading(BuildContext context, Stream<bool> stream) {
    final streamSubscription = stream.listen((isLoading) async {
      if (isLoading == true) {
        // isDialogShowing = true;
        showLoading(context);
      } else {
        hideLoading(context);
        // isDialogShowing = false;
      }
    });

    return streamSubscription;
  }
}
