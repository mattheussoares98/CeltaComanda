import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class ConfigurationsPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
}
