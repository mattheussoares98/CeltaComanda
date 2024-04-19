import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadApiSaleRequest implements LoadApiSaleRequest {
  final HttpClient httpAdapter;
  final String url;

  RemoteLoadApiSaleRequest({
    required this.httpAdapter,
    required this.url,
  });

  @override
  Future<ApiSaleRequestEntity?> load() async {
    try {
      final apiSaleRequest = await httpAdapter.request(
        url: "url",
        method: "get",
      );
      if (apiSaleRequest == null) throw Error();

      return ApiSaleRequestModel.fromJson(apiSaleRequest).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
