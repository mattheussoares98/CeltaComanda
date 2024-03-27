import '../entities/entities.dart';

abstract class SaveCurrentCrossId {
  Future<void> save(CrossIdEntity crossIdEntity);
}