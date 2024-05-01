import '../../../domain/entities/entities.dart';

abstract class UpdateSaleRequestTemp {
  Future<void> update({
    required String url,
    required SaleRequestTempEntity saleRequestTempEntity,
  });
}
