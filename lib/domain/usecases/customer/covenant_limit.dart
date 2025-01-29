import '../../../infra/helpers/helpers.dart';

abstract class CovenantLimit {
  Future<SoapResponse> authorizeCovenantLimitUseByCodeAndGetAuthorizeCode({
    required String? crossIdentity,
    required int covenantCode,
    required int customerCode,
    required double value,
  });
}
