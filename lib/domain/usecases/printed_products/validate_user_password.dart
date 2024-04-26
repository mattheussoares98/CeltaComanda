abstract class ValidateUserPassword {
  Future<bool> isValidPassword({
    required String url,
    required int personalizedCode,
    required String password,
  });
}
