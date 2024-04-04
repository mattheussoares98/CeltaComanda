import '../../domain/entities/entities.dart';

abstract class LoadLoginData {
  Future<LoginDataEntity?> load();
}
