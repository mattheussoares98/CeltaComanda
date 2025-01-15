import '../../entities/entities.dart';

abstract class UpdateEnterpriseParameters {
  Future<void> update(EnterpriseEntity enterprise);
}
