import '../../../data/models/models.dart';

abstract class GenerateBytes {
  Future<List<int>> generateRowWithColumns(
      List<PrintParametersModel> columnsParameters);
}
