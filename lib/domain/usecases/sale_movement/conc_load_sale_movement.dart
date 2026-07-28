import '../../entities/entities.dart';

abstract class ConcLoadSaleMovement {
  Future<List<SaleMovementConcentratorEntity>?> load({
    required String date,
    String? concentratorUrl,
    int? enterpriseId,
    int? concentratorPort,
  });
  Future<List<SaleMovementConcentratorEntity>?> loadDeliverySales({
    required String concentratorUrl,
    required int enterpriseId,
    required int concentratorPort,
  });
}
