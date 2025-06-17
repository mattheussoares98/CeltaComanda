import '../../../main/builders/builders.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteUpdateSaleRequest with ErrorHandling implements UpdateSaleRequest {
  final HttpClient httpAdapter;

  RemoteUpdateSaleRequest({
    required this.httpAdapter,
  });

  @override
  Future<void> update({
    required SaleRequestModel model,
    required String commandNumber,
    required int saleRequestId,
  }) async {
    try {
      final body = model.toJson();
      body["PersonalizedCode"] = commandNumber.padLeft(3, "0");
      body["SaleRequestId"] = saleRequestId;

      final response = await httpAdapter.request(
        url:
            "${EnterpriseBuilder.entity!.url}/api/apiSaleRequest/UpdateSaleRequest",
        method: "put",
        body: body,
      );

      response != null;
    } catch (e) {
      treatError(e);
    }
  }
}
