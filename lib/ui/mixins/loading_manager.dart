import 'dart:async';

import '../../main/builders/builders.dart';
import '../components/components.dart';

import 'package:flutter/material.dart';

mixin LoadingManager {
  StreamSubscription handleLoading(BuildContext context, Stream<bool> stream) {
    final streamSubscription = stream.listen((isLoading) async {
      if (isLoading == true) {
        showLoading(NavigatorKey.key.currentState?.context ?? context);
      } else {
        hideLoading(NavigatorKey.key.currentState?.context ?? context);
      }
    });

    return streamSubscription;
  }
}
