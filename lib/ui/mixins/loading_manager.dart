import '../../main/builders/builders.dart';
import '../components/components.dart';

import 'package:flutter/material.dart';

mixin LoadingManager {
  void handleLoading(BuildContext context, Stream<bool> stream) {
    stream.listen((isLoading) async {
      if (isLoading == true) {
        showLoading(NavigatorKey.navigatorKey.currentState?.context ?? context);
      } else {
        hideLoading(NavigatorKey.navigatorKey.currentState?.context ?? context);
      }
    });
  }
}
