import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSaleRequest implements LoadSaleRequest {
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
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url}/api/apiSaleRequest/Get?_enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}&_personalizedCode=$commandNumber&_considerUsing=true",
        method: "get",
      );
      if (saleRequest == null) {
        return null;
      }

      return SaleRequestModel.fromJson(saleRequest);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
