import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalPrintRequest
    implements AddPrintRequest, LoadPrintRequest, ClearSaleRequestTemp {
  final HiveStorage hiveStorage;

  LocalPrintRequest({required this.hiveStorage});

  @override
  Future<void> add() async {
    final newPrintRequest = await getMergedPrintedEntity();
    try {
      await hiveStorage.put(
        CacheKeys.printRequest.name,
        PrintRequestModel.fromEntity(newPrintRequest).toJson(),
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<PrintRequestEntity> getMergedPrintedEntity() async {
    try {
      final json = await hiveStorage.get(
        CacheKeys.printRequest.name,
      );

      if (json != null) {
        return PrintRequestEntity(
          dates: [
            ..._mapToEntity(json).dates,
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
          ],
          timesUsed: _mapToEntity(json).timesUsed + 1,
        );
      } else {
        return PrintRequestEntity(
          dates: [
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
          ],
          timesUsed: 1,
        );
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  PrintRequestEntity _mapToEntity(dynamic json) =>
      PrintRequestModel.fromJson(json).toEntity();

  @override
  Future<void> clear() async {
    try {
      await hiveStorage.delete(
        CacheKeys.printRequest.name,
      );
    } catch (e) {
      // throw DomainError.unexpected;
    }
  }
}
