import '../../entities/entities.dart';

abstract class LoadApiSaleRequest {
  Future<ApiSaleRequestEntity?> load(
      ApiSaleRequestEntity? apiSaleRequestEntity);
}
