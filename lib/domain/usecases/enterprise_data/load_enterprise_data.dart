import '../../entities/entities.dart';

abstract class LoadEnterpriseData {
  Future<EnterpriseEntity?> load();
}
