import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteUpdateProductComment implements UpdateProductComment {
  final HttpClient httpAdapter;

  RemoteUpdateProductComment({
    required this.httpAdapter,
  });

  @override
  Future<void> update({
    required String url,
    required int saleRequestProductTempId,
    required String comments,
  }) async {
    try {
      final response = await httpAdapter.request(
        url:
            "$url/api/APISaleRequestProduct/UpdateSaleRequestProductComments?_saleRequestProductTempId=$saleRequestProductTempId&_comments=$comments",
        method: "get",
      );

      response != null;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
