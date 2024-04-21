import 'package:get/get.dart';

import 'package:flutter/material.dart';

mixin TextControllerManager on GetxController {
  final _enterpriseNameController = TextEditingController();

  TextEditingController get enterpriseNameController =>
      _enterpriseNameController;

  void updateEnterpriseController(String value) {
    _enterpriseNameController.text = value;
  }
}
