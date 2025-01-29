import '../../entities/entities.dart';

abstract class LastImport {
  Future<LastImportEntity?> load();
  Future<void> save(LastImportEntity? entity);
}
