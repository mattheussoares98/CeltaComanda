import '../../entities/entities.dart';

abstract class LoadEnterpriseConcentradorParameters {
  Future<EnterpriseConcentradorParametersEntity> load({
    required int enterpriseId,
    required String concentradorUrl,
  });
}
