import '../../entities/entities.dart';

abstract class LoadEnterpriseConcentradorParameters {
  Future<EnterpriseConcentradorParametersEntity> load(int enterpriseId);
}
