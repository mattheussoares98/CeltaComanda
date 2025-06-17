import '../../../domain/entities/product_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';

class RemoteSearchProductByCode
    with ErrorHandling
    implements SearchProductByCode {
  final HttpClient httpAdapter;

  RemoteSearchProductByCode({
    required this.httpAdapter,
  });

  @override
  Future<ProductEntity?> search({
    required String url,
    required String value,
    required int enterpriseId,
  }) async {
    try {
      final response = await httpAdapter.request(
          url:
              "$url/api/APIProduct/get?_enterpriseId=$enterpriseId&_productCode=$value",
          method: "get");

      if (response == null) {
        throw DomainError.productNotFound;
      }

      return ProductModel.fromJson(response).toEntity();
    } catch (e) {
      treatError(e);
    }
  }
}
