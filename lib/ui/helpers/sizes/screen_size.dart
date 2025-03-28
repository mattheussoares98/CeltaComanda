import 'package:flutter/material.dart';

class ScreenSize {
  ScreenSize._();

  static bool _hasMinWidth = false;
  static bool get hasMinWidth => _hasMinWidth;
  static void updateHasMinWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width > 900) {
      _hasMinWidth = true;
    } else {
      _hasMinWidth = false;
    }
  }
}
