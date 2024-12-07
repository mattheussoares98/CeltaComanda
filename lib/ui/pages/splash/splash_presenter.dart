import 'package:flutter/material.dart';

import '../home/home.dart';

abstract class SplashPresenter implements Listenable {
  Future<void> checkPageToGo({
    required HomePresenter homePresenter,
    int durationInSeconds,
  });
}
