import '../../entities/conc_sale_request/conc_sale_request.dart';
import '../../entities/entities.dart';

abstract class ConcLoadSaleRequest {
  Future<List<ConcSaleRequestEntity>> load({
    required SettingsEntity settings,
    required String personalizedCode,
  });
}
