import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/databases/databases.dart';

class FirebaseAuthLoginManagement implements LoginManagement {
  final FirebaseAuthAdapter firebaseAuthAdapter;

  FirebaseAuthLoginManagement({required this.firebaseAuthAdapter});

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuthAdapter.login(email: email, password: password);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuthAdapter.logout();
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
