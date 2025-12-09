import '../../entities/conc_sale_request/conc_sale_request.dart';
import '../../entities/entities.dart';

abstract class ConcLoadSaleRequest {
  Future<ConcSaleRequestEntity> load({
    required WebLocalSettingsEntity settings,
    required String personalizedCode,
  });
}
