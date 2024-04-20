import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadApiSaleRequest implements LoadApiSaleRequest {
  final HttpClient httpAdapter;

  RemoteLoadApiSaleRequest({
    required this.httpAdapter,
  });

  @override
  Future<ApiSaleRequestEntity?> load({
    required String url,
    required int enterpriseId,
  }) async {
    try {
      final apiSaleRequest = await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/GetTemp?_enterpriseId=$enterpriseId&_personalizedCode=001",
        method: "get",
      );
      if (apiSaleRequest == null) throw Error();

      return ApiSaleRequestModel.fromJson(apiSaleRequest).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
