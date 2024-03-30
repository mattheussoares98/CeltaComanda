import 'package:get/get.dart';

import 'package:flutter/material.dart';

mixin FocusNodeManager on GetxController {
  final _passwordFocusNode = FocusNode();
  final _urlCcsFocusNode = FocusNode();

  FocusNode get passwordFocusNode => _passwordFocusNode;
  FocusNode get urlCcsFocusNode => _urlCcsFocusNode;

  void changeFocus(FocusNode nextFocus) {
    FocusScope.of(Get.context!).requestFocus(nextFocus);
  }
}
