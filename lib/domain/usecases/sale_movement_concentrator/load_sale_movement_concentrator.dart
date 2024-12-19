import '../../entities/entities.dart';

abstract class LoadSaleMovementConcentrator {
  Future<List<SaleMovementConcentratorEntity>> load({required String date});
}
