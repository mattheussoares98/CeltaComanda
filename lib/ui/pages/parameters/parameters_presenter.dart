import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';

abstract class ParametersPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<ParameterModel>?> get parametersStream;

  Future<void> changeParameter(int index);
  Future<void> loadParameters();
}
