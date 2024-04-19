import 'package:flutter/material.dart';

abstract class SplashPresenter implements Listenable {
  Future<void> checkApiSaleRequest({int durationInSeconds});
}