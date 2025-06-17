import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';

class RemoteLoadSaleRequest with ErrorHandling implements LoadSaleRequest {
  final HttpClient httpAdapter;

  RemoteLoadSaleRequest({
    required this.httpAdapter,
  });

  @override
  Future<SaleRequestModel?> load({
    required int commandNumber,
  }) async {
    try {
      final saleRequest = await httpAdapter.request(
        url:
            "${EnterpriseBuilder.entity!.url}/api/apiSaleRequest/Get?_enterpriseId=${EnterpriseBuilder.entity!.enterpriseId}&_personalizedCode=$commandNumber&_considerUsing=true",
        method: "get",
      );
      if (saleRequest == null) {
        return null;
      }

      return SaleRequestModel.fromJson(saleRequest);
    } catch (e) {
      treatError(e);
    }
  }
}
