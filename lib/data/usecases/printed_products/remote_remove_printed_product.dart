import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';

class RemoteRemovePrintedProduct
    with ErrorHandling
    implements RemovePrintedProduct {
  final HttpClient httpAdapter;

  RemoteRemovePrintedProduct({
    required this.httpAdapter,
  });

  @override
  Future<void> remove(String productId) async {
    try {
      await httpAdapter.request(
        url:
            "${EnterpriseBuilder.entity!.url}/api/APISaleRequestProduct/DeleteSaleRequestProduct?id=$productId",
        method: "get",
      );
    } catch (e) {
      treatError(e);
    }
  }
}
