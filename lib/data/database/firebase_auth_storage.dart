abstract class FirebaseAuthStorage {
  Future<void> login({
    required String email,
    required String password,
  });
  Future<void> logout();
}
