import 'package:get/get.dart';

import 'package:flutter/material.dart';

mixin FocusNodeManager on GetxController {
  final _passwordFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();

  FocusNode get passwordFocusNode => _passwordFocusNode;
  FocusNode get urlFocusNode => _urlFocusNode;

  void changeFocus(FocusNode nextFocus) {
    FocusScope.of(Get.context!).requestFocus(nextFocus);
  }
}
