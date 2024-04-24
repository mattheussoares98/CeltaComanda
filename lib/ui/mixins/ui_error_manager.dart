import '../../main/builders/builders.dart';
import '../components/components.dart';
import '../helpers/errors/errors.dart';

import 'package:flutter/material.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<UIError?> stream) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(NavigatorKey.navigatorKey.currentState?.context ?? context, error.description);
      }
    });
  }
}