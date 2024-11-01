import '../../../data/models/models.dart';

abstract class LoadSaleRequest {
  Future<SaleRequestModel?> load({required int commandNumber});
}
