import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';

class LocalPrintRequest
    implements AddPrintRequest, LoadPrintRequest, ClearSaleRequestTemp {
  final HiveStorage hiveStorage;

  LocalPrintRequest({required this.hiveStorage});

  @override
  Future<void> add(PrintRequestEntity entity) async {
    try {
      await hiveStorage.put(
        CacheKeys.printRequest.name,
        PrintRequestModel.fromEntity(entity).toJson(),
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<PrintRequestEntity?> getLocalPrintedEntity() async {
    try {
      final json = await hiveStorage.get(
        CacheKeys.printRequest.name,
      );

      if (json != null) {
        return _mapToEntity(json);
      } else {
        return null;
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
      throw DomainError.unexpected;
    }
  }
}
