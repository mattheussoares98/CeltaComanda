import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import '../../presentation/mixins/mixins.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxParametersPresenter extends GetxController
    with LoadingManager, UIErrorManager
    implements ParametersPresenter {
  final NavigateTo navigateTo;
  final ParametersData parametersData;

  GetxParametersPresenter({
    required this.navigateTo,
    required this.parametersData,
  });

  @override
  Future<void> changeParameter(int index) async {
    isLoading = true;
    mainError = null;

    try {
      final newParameters = [...await parametersData.load()];
      final oldParameter = newParameters[index];
      final newParameter = ParameterModel(
        enabled: !oldParameter.enabled,
        name: oldParameter.name,
      );

      newParameters[index] = newParameter;

      parameters = newParameters;

      await parametersData.update(newParameters);
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }

  final _parameters = Rx<List<ParameterModel>?>(null);
  @override
  Stream<List<ParameterModel>?> get parametersStream => _parameters.stream;
  set parameters(List<ParameterModel>? value) => _parameters.value = value;

  @override
  Future<void> loadParameters() async {
    isLoading = true;
    mainError = null;
    parameters = null;

    try {
      final loadedParameters = await parametersData.load();

      parameters = loadedParameters;
    } catch (e) {
      mainError = UIError.unexpected;
    } finally {
      isLoading = false;
    }
  }
}
