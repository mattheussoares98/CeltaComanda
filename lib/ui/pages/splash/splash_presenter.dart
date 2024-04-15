import 'package:flutter/material.dart';

abstract class SplashPresenter implements Listenable {
  Future<void> checkAccount({int durationInSeconds});
}