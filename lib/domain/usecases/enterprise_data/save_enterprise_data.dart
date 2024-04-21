import '../../entities/entities.dart';

abstract class SaveEnterpriseData {
  Future<void> add(EnterpriseEntity enterpriseData);
}
