abstract class AuthorizeCovenantLimitUseByCode {
  Future<void> authorize({
    required String? crossIdentity,
    required int covenantCode,
    required int customerCode,
    required double value,
  });
}
