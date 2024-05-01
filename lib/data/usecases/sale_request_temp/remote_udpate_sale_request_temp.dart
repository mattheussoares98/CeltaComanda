import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/entities/sale_request_temp_entity.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteUpdateSaleRequestTemp implements UpdateSaleRequestTemp {
  final HttpClient httpAdapter;

  RemoteUpdateSaleRequestTemp({
    required this.httpAdapter,
  });

  @override
  Future<void> update({
    required String url,
    required SaleRequestTempEntity saleRequestTempEntity,
  }) async {
    try {
      await httpAdapter.request(
        url: "$url/api/apiSaleRequest/UpdateSaleRequestTemp",
        method: "get",
        body: SaleRequestTempModel.fromEntity(saleRequestTempEntity).toJson(),
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
