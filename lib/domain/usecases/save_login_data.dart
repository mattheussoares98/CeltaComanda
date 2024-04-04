import '../entities/entities.dart';

abstract class SaveLoginData {
  Future<void> save(LoginDataEntity loginData);
}
