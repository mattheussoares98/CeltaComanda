import '../../entities/entities.dart';

abstract class LoadCommandsAvailable {
  Future<SaleRequestEntity?> load({
    required String url,
    required int enterpriseId,
    required String commandNumber,
  });
}
