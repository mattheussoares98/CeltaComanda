import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalLoadCommandData implements LocalCommandData {
  final HiveStorage hiveStorage;

  LocalLoadCommandData({required this.hiveStorage});

  @override
  Future<CommandEntity> load() async {
    try {
      final json = await hiveStorage.get(
        CacheKeys.commandData.name,
      );
      if (json != null) {
        return CommandModel.fromJson(json).toEntity();
      } else {
        throw Exception();
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> update(CommandEntity entity) async {
    try {
      await hiveStorage.put(
        CacheKeys.commandData.name,
        CommandModel.fromEntity(entity).toJson(),
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
