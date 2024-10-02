abstract class FinishSaleRequestConcentrador {
  Future<void> finish({
    required int pdvNumber,
    required int commandNumber,
    required int? finalizationIdentification,
  });
}
