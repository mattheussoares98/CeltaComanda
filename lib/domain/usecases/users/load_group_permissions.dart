import '../../entities/entities.dart';

abstract class LoadGroupPermissions {
  Future<List<GroupPermissionConcentratorEntity>> getAll();
}
