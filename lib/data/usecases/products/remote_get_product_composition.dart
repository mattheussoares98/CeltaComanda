import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';
import '../../http/http_client.dart';
import '../../models/models.dart';

class RemoteGetProductComposition extends GetProductComposition {
  final HttpClient httpAdapter;

  RemoteGetProductComposition(this.httpAdapter);

  @override
  Future<List<ProductCompositionEntity>> get({
    required String url,
    required int enterpriseId,
    required int internalCodeOnErp,
  }) async {
    try {
      final response = await httpAdapter.request(
          url:
              "$url/api/APIProduct/getproductcomposition?_enterpriseId=$enterpriseId&_internalCodeOnERPCodeFather=$internalCodeOnErp",
          method: "get");

      if (response == null) {
        throw DomainError.unexpected;
      }

      return response
          .map<ProductCompositionEntity>(
              (element) => ProductCompositionModel.fromJson(element).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
