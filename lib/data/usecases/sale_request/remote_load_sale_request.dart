import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadSaleRequest implements LoadSaleRequest {
  final HttpClient httpAdapter;

  RemoteLoadSaleRequest({
    required this.httpAdapter,
  });

  @override
  Future<void> load({
    required int commandNumber,
  }) async {
    try {
      final saleRequestTemp = await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url}/api/apiSaleRequest/Get?_enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}&_personalizedCode=$commandNumber&_considerUsing=true",
        method: "get",
      );
      if (saleRequestTemp == null) throw Error();

      // return SaleRequestModel.fromJson(saleRequestTemp).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
