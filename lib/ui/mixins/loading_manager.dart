import 'dart:async';

import '../../main/builders/builders.dart';
import '../components/components.dart';

import 'package:flutter/material.dart';

mixin LoadingManager {
  static bool isDialogShowing = false;
  StreamSubscription handleLoading(BuildContext context, Stream<bool> stream) {
    final streamSubscription = stream.listen((isLoading) async {
      if (isLoading == true && !isDialogShowing) {
        isDialogShowing = true;
        showLoading(NavigatorKey.navigatorKey.currentState?.context ?? context);
      } else {
        hideLoading(NavigatorKey.navigatorKey.currentState?.context ?? context);
        isDialogShowing = false;
      }
    });

    return streamSubscription;
  }
}
