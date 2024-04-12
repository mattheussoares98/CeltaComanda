import '../../entities/entities.dart';

abstract class SaveLoginData {
  Future<void> add(LoginDataEntity loginData);
}
