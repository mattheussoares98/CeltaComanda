import '../../mixins/mixins.dart';
import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteUpdateSaleRequestTemp
    with ErrorHandling
    implements UpdateSaleRequestTemp {
  final HttpClient httpAdapter;

  RemoteUpdateSaleRequestTemp({
    required this.httpAdapter,
  });

  @override
  Future<void> update({
    required String url,
    required UpdateSaleRequestTempEntity entity,
  }) async {
    try {
      final body = UpdateSaleRequestTempModel.fromEntity(entity).toJson();
      final response = await httpAdapter.request(
        url: "$url/api/apiSaleRequest/UpdateSaleRequestTemp",
        method: "post",
        body: body,
      );

      response != null;
    } catch (e) {
      treatError(e);
    }
  }
}
