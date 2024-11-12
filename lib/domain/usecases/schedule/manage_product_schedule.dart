import '../../entities/entities.dart';

abstract class ManageProductSchedule {
  Future<void> insertUpdate(ProductScheduleEntity entity);
  Future<List<ProductScheduleEntity>> get(int internalCodeOnErp);
  Future<void> delete(int internalCodeOnErp);
}
