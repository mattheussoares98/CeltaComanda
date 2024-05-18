import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../infra/http/http.dart';
import '../../models/models.dart';

class RemoteGetProductComposition extends GetProductComposition {
  final HttpAdapter httpAdapter;

  RemoteGetProductComposition(this.httpAdapter);

  @override
  Future<List<ProductCompositionEntity>> getProducts({
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

      return response
          .map(
              (element) => ProductCompositionModel.fromJson(element).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
