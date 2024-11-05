import '../../../main/builders/builders.dart';
import '../../http/http_client.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteFinishSaleRequestTempById implements FinishSaleRequestTempById {
  final HttpClient httpAdapter;

  RemoteFinishSaleRequestTempById({required this.httpAdapter});

  @override
  Future<void> finish(int saleRequestTempId) async {
    try {
      await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url}/api/apiSaleRequest/FinishTempById?saleRequestTempId=$saleRequestTempId",
        method: "post",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
