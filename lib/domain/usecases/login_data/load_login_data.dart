import '../../entities/entities.dart';

abstract class LoadLoginData {
  Future<LoginDataEntity?> load({LoginDataEntity? loginEntity});
}
