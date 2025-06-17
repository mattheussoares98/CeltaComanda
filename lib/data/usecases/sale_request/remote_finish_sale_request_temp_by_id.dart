import '../../../main/builders/builders.dart';
import '../../http/http_client.dart';
import '../../../domain/usecases/usecases.dart';
import '../../mixins/mixins.dart';

class RemoteFinishSaleRequestTempById
    with ErrorHandling
    implements FinishSaleRequestTempById {
  final HttpClient httpAdapter;

  RemoteFinishSaleRequestTempById({required this.httpAdapter});

  @override
  Future<void> finish(int saleRequestTempId) async {
    try {
      await httpAdapter.request(
        url:
            "${EnterpriseBuilder.entity!.url}/api/apiSaleRequest/FinishTempById?saleRequestTempId=$saleRequestTempId",
        method: "post",
      );
    } catch (e) {
      treatError(e);
    }
  }
}
