import '../../../data/models/models.dart';

abstract class UpdateSaleRequest {
  Future<void> update({
    required SaleRequestModel model,
    required String commandNumberWithThreeNumbers,
    required int saleRequestId,
  });
}
