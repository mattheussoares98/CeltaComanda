import 'dart:async';

import 'package:flutter/material.dart';

mixin UpdateScreenManager {
  StreamSubscription handleUpdateScreen(
    BuildContext context,
    Stream<bool> stream,
    Function() setState,
  ) {
    final streamSubscription = stream.listen((update) async {
      if (update == true) {
        setState();
      }
    });

    return streamSubscription;
  }
}
