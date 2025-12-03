import '../../../data/models/models.dart';

abstract class LoadOpenSaleRequest {
  Future<List<SaleRequestModel>> load({required bool isConsiderDelivered});
}
