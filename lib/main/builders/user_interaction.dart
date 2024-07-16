import 'dart:async';

import 'package:flutter/material.dart';

class UserInteraction {
  UserInteraction._();

  static void handleUserInteraction([_]) {
    _timer.cancel();
    _initializeTimer();
  }

  static void _executeFunctions() {
    // Execute suas funções aqui
    debugPrint('Usuário inativo por 5 segundos');
    _timer.cancel();
  }

  static Timer _timer =
      Timer.periodic(const Duration(seconds: 5), (_) => _executeFunctions());

  static void _initializeTimer() {
    _timer =
        Timer.periodic(const Duration(seconds: 5), (_) => _executeFunctions());
  }
}
