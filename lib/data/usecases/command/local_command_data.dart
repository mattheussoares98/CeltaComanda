import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';
import '../../mixins/mixins.dart';

class LocalLoadCommandData with ErrorHandling implements LocalCommandData {
  final HiveStorage hiveStorage;

  LocalLoadCommandData({required this.hiveStorage});

  @override
  Future<CommandEntity?> load() async {
    try {
      final json = await hiveStorage.get(
        CacheKeys.commandData.name,
      );
      if (json != null) {
        return CommandModel.fromJson(json).toEntity();
      }
      return null;
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<void> update(CommandEntity entity) async {
    try {
      await hiveStorage.put(
        CacheKeys.commandData.name,
        CommandModel.fromEntity(entity).toJson(),
      );
    } catch (e) {
      treatError(e);
    }
  }
}
