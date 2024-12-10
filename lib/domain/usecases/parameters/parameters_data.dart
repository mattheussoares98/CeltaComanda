import '../../../data/models/models.dart';

abstract class ParametersData {
  Future<void> update(List<ParametersModel> value);
  Future<List<ParametersModel>> load();
}
