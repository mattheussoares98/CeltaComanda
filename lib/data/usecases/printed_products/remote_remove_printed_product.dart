import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteRemovePrintedProduct implements RemovePrintedProduct {
  final HttpClient httpAdapter;

  RemoteRemovePrintedProduct({
    required this.httpAdapter,
  });

  @override
  Future<void> remove(String productId) async {
    try {
      await httpAdapter.request(
        url:
            "${EnterpriseDataBuilder.enterpriseDataEntity!.url}/api/APISaleRequestProduct/DeleteSaleRequestProduct?id=$productId",
        method: "get",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
