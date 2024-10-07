import '../../../main/builders/builders.dart';
import '../../models/models.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteUpdateSaleRequest implements UpdateSaleRequest {
  final HttpClient httpAdapter;

  RemoteUpdateSaleRequest({
    required this.httpAdapter,
  });

  @override
  Future<void> update(SaleRequestModel model) async {
    try {
      final body = model.toJson();

      final response = await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url}/api/apiSaleRequest/UpdateSaleRequest",
        method: "post",
        body: body,
      );

      response != null;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
