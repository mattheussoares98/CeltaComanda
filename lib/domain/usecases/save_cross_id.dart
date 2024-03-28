import '../entities/entities.dart';

abstract class SaveCrossId {
  Future<void> save(CrossIdEntity? crossIdEntity);
}