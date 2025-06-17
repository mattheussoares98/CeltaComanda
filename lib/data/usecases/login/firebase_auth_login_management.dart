import '../../../domain/usecases/usecases.dart';
import '../../../infra/databases/databases.dart';
import '../../mixins/mixins.dart';

class FirebaseAuthLoginManagement
    with ErrorHandling
    implements LoginManagement {
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
      treatError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuthAdapter.logout();
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<bool> isLoggedIn() async => await firebaseAuthAdapter.isLoggedIn();
}
