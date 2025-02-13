import '../../entities/entities.dart';

abstract class LoadUsers {
  Future<List<UserConcentratorEntity>> getAll({
    required bool loadLocally,
  });
}
