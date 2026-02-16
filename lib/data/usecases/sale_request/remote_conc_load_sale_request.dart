import '../../../domain/entities/conc_sale_request/conc_sale_request.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';
import '../../models/conc_sale_request/conc_sale_request.dart';

class RemoteConcLoadSaleRequest
    with ErrorHandling
    implements ConcLoadSaleRequest {
  final HttpClient httpAdapter;
  RemoteConcLoadSaleRequest(this.httpAdapter);

  @override
  Future<ConcSaleRequestEntity> load({
    required WebLocalSettingsEntity settings,
    required String personalizedCode,
  }) async {
    try {
      final response = await httpAdapter.request(
        url:
            '${settings.defaultUrl}:${settings.concentratorPort}/api/APISaleRequest/GetSaleRequest?enterpriseId=${settings.enterpriseId}&personalizedCode=$personalizedCode&considerUsing=true',
        method: "get",
        headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
      );

      return ConcSaleRequestModel.fromJson((response as List).first).toEntity();
    } catch (e) {
      treatError(e);
    }
  }
}
