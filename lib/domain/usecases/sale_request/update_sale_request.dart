import '../../../data/models/models.dart';

abstract class UpdateSaleRequest {
  Future<void> update({
    required SaleRequestModel model,
    required String commandNumber,
    required int saleRequestId,
  });
}
