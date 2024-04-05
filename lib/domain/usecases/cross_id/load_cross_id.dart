import '../../entities/entities.dart';

abstract class LoadCrossId {
  Future<CrossIdEntity?> load();
}