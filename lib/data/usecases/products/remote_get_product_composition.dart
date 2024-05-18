import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../infra/http/http.dart';
import '../../models/models.dart';

class RemoteGetProductComposition extends GetProductComposition {
  final HttpAdapter httpAdapter;

  RemoteGetProductComposition(this.httpAdapter);

  @override
  Future<ProductCompositionEntity> getProducts({
    required String url,
    required int enterpriseId,
    required int internalCodeOnERPCodeFather,
  }) async {
    try {
      final response = await httpAdapter.request(
          url:
              "$url/api/APIProduct/getproductcomposition?_enterpriseId=$enterpriseId&_internalCodeOnERPCodeFather=$internalCodeOnERPCodeFather",
          method: "get");

      if (response == null) {
        throw DomainError.unexpected;
      }

      return ProductCompositionModel.fromJson(response).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
