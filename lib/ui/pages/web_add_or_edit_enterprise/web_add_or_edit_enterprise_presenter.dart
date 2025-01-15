import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';

abstract class WebAddOrEditEnterprisePresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;

  void updateEnterprise(EnterpriseEntity enterprise);
}
