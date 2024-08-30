import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteUpdateProductQuantity implements UpdateProductQuantity {
  final HttpClient httpAdapter;

  RemoteUpdateProductQuantity({
    required this.httpAdapter,
  });

  @override
  Future<void> add({
    required String url,
    required int saleRequestProductTempId,
  }) async {
    try {
      await httpAdapter.request(
        url:
            "$url/api/APISaleRequestProduct/UpdateQuantityPlus?_saleRequestProductTempId=$saleRequestProductTempId",
        method: "get",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> subtract({
    required String url,
    required int saleRequestProductTempId,
  }) async {
    try {
      await httpAdapter.request(
        url:
            "$url/api/APISaleRequestProduct/UpdateQuantityMinus?_saleRequestProductTempId=$saleRequestProductTempId",
        method: "get",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> delete({
    required String url,
    required int saleRequestProductTempId,
  }) async {
    try {
      await httpAdapter.request(
        url:
            "$url/api/APISaleRequestProduct/DeleteSaleRequestProductTemp?id=$saleRequestProductTempId",
        method: "get",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
