import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/pages/pages.dart';

class GetxParametersPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements ParametersPresenter {
  final NavigateTo navigateTo;

  GetxParametersPresenter({
    required this.navigateTo,
  });

  @override
  Future<void> enableSearchProducts() async {}

  final _parameters = Rx<List<ParametersModel>?>(null);
  @override
  Stream<List<ParametersModel>?> get parametersStream => _parameters.stream;
}
