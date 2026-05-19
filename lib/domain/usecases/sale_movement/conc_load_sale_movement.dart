import '../../entities/entities.dart';

abstract class ConcLoadSaleMovement {
  Future<List<SaleMovementConcentratorEntity>?> load({required String date});
  Future<List<SaleMovementConcentratorEntity>?> loadDeliverySales(
    int enterpriseId,
  );
}
