abstract class CovenantLimit {
  Future<dynamic> authorizeCovenantLimitUseByCodeAndGetAuthorizeCode({
    required String? crossIdentity,
    required int covenantCode,
    required int customerCode,
    required double value,
  });
}
