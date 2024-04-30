import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import '../../../domain/helpers/helpers.dart';
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
      final saleRequestTemp = await httpAdapter.request(
        url:
            "$url/api/APISaleRequestProduct/UpdateQuantityPlus?_saleRequestProductTempId=$saleRequestProductTempId",
        method: "get",
      );
      if (saleRequestTemp == null) throw Error();
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
      final saleRequestTemp = await httpAdapter.request(
        url:
            "$url/api/APISaleRequestProduct/UpdateQuantityMinus?_saleRequestProductTempId=$saleRequestProductTempId",
        method: "get",
      );
      if (saleRequestTemp == null) throw Error();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
