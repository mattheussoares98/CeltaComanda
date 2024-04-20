import '../../entities/entities.dart';

abstract class LoadApiSaleRequest {
  Future<ApiSaleRequestEntity?> load({
    required String url,
    required int enterpriseId,
  });
}
