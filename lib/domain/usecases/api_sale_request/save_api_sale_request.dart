import '../../entities/entities.dart';

abstract class SaveApiSaleRequest {
  Future<void> save(SaleRequestEntity apiSaleRequestEntity);
}
