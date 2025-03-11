import '../../entities/entities.dart';

abstract class ConcInsertSaleMovement {
  Future<int> insert(SaleMovementConcentratorEntity sale);
}
