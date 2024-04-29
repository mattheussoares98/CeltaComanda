import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteRemoveSaleRequestProductComment
    implements UpdateSaleRequestproductComment {
  final HttpClient httpAdapter;

  RemoteRemoveSaleRequestProductComment({required this.httpAdapter});

  @override
  Future<void> updateComment({
    required String comment,
    required String url,
    required int saleRequestProductTempId,
  }) async {
    try {
      await httpAdapter.request(
        url:
            "$url/api/APISaleRequestProduct/UpdateSaleRequestProductComments?_saleRequestProductTempId=$saleRequestProductTempId&_comments=$comment",
        method: "get",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
