import '../../entities/entities.dart';

abstract class LoadCommandsAvailable {
  Future<ApiSaleRequestEntity?> load({
    required String url,
    required int enterpriseId,
    required String commandNumber,
  });
}
