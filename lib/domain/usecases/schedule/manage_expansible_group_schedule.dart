import '../../entities/entities.dart';

abstract class ManageExpansibleGroupSchedule {
  Future<void> insertUpdate(ExpansibleGroupScheduleEntity entity);
  Future<List<ExpansibleGroupScheduleEntity>> get(int expansibleGroupId);
  Future<void> delete(int expansibleGroupId);
}
