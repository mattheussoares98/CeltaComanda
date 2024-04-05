import 'package:get/get.dart';

import 'package:flutter/material.dart';

mixin TextControllerManager on GetxController {
  final _userController = TextEditingController();
  final _urlController = TextEditingController();

  TextEditingController get userNameController => _userController;
  TextEditingController get urlController => _urlController;

  void updateUserController(String value) {
    _userController.text = value;
  }

  void updateUrlController(String value) {
    _urlController.text = value;
  }
}
