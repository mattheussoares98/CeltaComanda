import '../../entities/entities.dart';

abstract class ConcentratorLogin {
  Future<UserConcentratorEntity?> login({
    required String username,
    required String password,
  });
}
