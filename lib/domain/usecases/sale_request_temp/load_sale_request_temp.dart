import '../../entities/entities.dart';

abstract class LoadSaleRequestTemp {
  Future<SaleRequestTempEntity> load({
    required String url,
    required int enterpriseId,
    required String commandNumber,
  });
}
