abstract class UserValidations {
  Future<bool> isValidPassword({
    required String url,
    required int personalizedCode,
    required String password,
  });

  Future<bool> canCancel({
    required int personalizedCode,
    required String url,
  });
}
