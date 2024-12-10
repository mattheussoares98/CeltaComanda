import '../../../data/models/models.dart';

abstract class ParametersData {
  Future<void> update(List<ParameterModel> value);
  Future<List<ParameterModel>> load();
}
