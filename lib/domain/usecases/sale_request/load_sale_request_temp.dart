import '../../entities/entities.dart';

abstract class LoadSaleRequestTemp {
  Future<SaleRequestTempEntity> load({
    required String commandNumber,
  });
}
