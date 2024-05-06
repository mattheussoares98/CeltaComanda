import '../../entities/entities.dart';

abstract class FinishSaleRequestTemp {
  Future<void> finish({
    required SaleRequestTempEntity saleRequestTempEntity,
    required String url,
  });
}
