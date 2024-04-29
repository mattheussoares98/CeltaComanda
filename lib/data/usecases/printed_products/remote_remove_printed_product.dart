import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteRemovePrintedProduct implements RemovePrintedProduct {
  final HttpClient httpAdapter;

  RemoteRemovePrintedProduct({
    required this.httpAdapter,
  });

  @override
  Future<void> remove({
    required String productId,
    required String url,
  }) async {
    try {
      await httpAdapter.request(
        url:
            "$url/api/APISaleRequestProduct/DeleteSaleRequestProduct?id=$productId",
        method: "get",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
