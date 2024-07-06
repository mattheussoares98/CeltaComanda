import '../../../domain/entities/entities.dart';

abstract class LoadCommandData {
  Future<CommandEntity?> load();
  Future<void> update(CommandEntity commandEntity);
}
