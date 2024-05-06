import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';

import '../../../data/http/http_client.dart';
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
    final body =
        SaleRequestTempModel.fromEntity(saleRequestTempEntity).toJson();
    body.toString();
    try {
      await httpAdapter.request(
        url: "$url/api/apiSaleRequest/FinishSaleRequestTemp",
        method: "post",
        body: body,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
