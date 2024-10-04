import '../../../data/models/models.dart';

abstract class FinishSaleRequestConcentrador {
  Future<void> finish({
    required int pdvNumber,
    required int commandNumber,
    required List<ConcentratorFinalizationModel>? finalizations,
  });
}
