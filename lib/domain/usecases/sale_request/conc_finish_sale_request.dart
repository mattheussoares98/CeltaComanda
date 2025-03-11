import '../../../data/models/models.dart';

abstract class ConcFinishSaleRequest {
  Future<void> finish({
    required int pdvNumber,
    required int commandNumber,
    required List<ConcentratorFinalizationModel>? finalizations,
  });
}
