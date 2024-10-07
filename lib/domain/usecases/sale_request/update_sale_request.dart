import '../../../data/models/models.dart';

abstract class UpdateSaleRequest {
  Future<void> update(SaleRequestModel model);
}
