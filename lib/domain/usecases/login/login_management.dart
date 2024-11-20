abstract class LoginManagement {
  Future<void> login({
    required String email,
    required String password,
  });
  Future<void> signOut();
}
