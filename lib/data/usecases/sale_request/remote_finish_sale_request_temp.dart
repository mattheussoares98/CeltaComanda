import '../../mixins/mixins.dart';
import '../../models/models.dart';
import '../../http/http_client.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteFinishSaleRequestTemp
    with ErrorHandling
    implements FinishSaleRequestTemp {
  final HttpClient httpAdapter;

  RemoteFinishSaleRequestTemp({required this.httpAdapter});

  @override
  Future<void> finish({
    required SaleRequestTempEntity saleRequestTempEntity,
    required String url,
  }) async {
    final body =
        SaleRequestTempModel.fromEntity(saleRequestTempEntity).toJson();
    body.toString();
    try {
      await httpAdapter.request(
        url: "$url/api/apiSaleRequest/FinishSaleRequestTemp",
        method: "post",
        body: body,
      );
    } catch (e) {
      treatError(e);
    }
  }
}
