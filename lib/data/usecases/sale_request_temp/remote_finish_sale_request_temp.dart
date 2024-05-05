import '../../../../data/models/models.dart';
import '../../../data/http/http_client.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteFinishSaleRequestTemp implements FinishSaleRequestTemp {
  final HttpClient httpAdapter;

  RemoteFinishSaleRequestTemp({required this.httpAdapter});

  @override
  Future<void> finish({
    required SaleRequestTempEntity saleRequestTempEntity,
    required String url,
  }) async {
    try {
      final saleRequestTemp = await httpAdapter.request(
        url: "$url/api/apiSaleRequest/FinishSaleRequestTemp",
        method: "post",
        body: SaleRequestTempModel.fromEntity(saleRequestTempEntity).toJson(),
      );
      if (saleRequestTemp == null) throw Error();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
