abstract class ValidateUserPassword {
  Future<bool> validateUser({
    required String url,
    required int personalizedCode,
    required String password,
  });
}
