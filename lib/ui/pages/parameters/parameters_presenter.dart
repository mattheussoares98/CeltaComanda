import 'package:flutter/material.dart';

import '../../../data/models/models.dart';
import '../../helpers/helpers.dart';

abstract class ParametersPresenter implements Listenable {
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get isLoadingStream;
  Stream<List<ParametersModel>?> get parametersStream;

  Future<void> enableSearchProducts();
  //TODO na implementação do presenter, criar um usecase para carregar e escrever os dados dos parâmetros
}
