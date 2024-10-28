import 'dart:async';

import '../../main/builders/builders.dart';
import '../components/components.dart';

import 'package:flutter/material.dart';

mixin AlertMessageManager {
  StreamSubscription handleAlertMessage(
      BuildContext context, Stream<String?> stream) {
    final streamSubscription = stream.listen((message) {
      if (message != null) {
        snackBarMessage(
          NavigatorKey.navigatorKey.currentState?.context ?? context,
          message,
        );
      }
    });
    return streamSubscription;
  }
}
