import '../../../domain/entities/entities.dart';

abstract class LocalCommandData {
  Future<CommandEntity?> load();
  Future<void> update(CommandEntity commandEntity);
}
