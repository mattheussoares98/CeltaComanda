import 'package:clean_celta_mobile/data/models/sale_request_model.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadOpenSaleRequest implements LoadOpenSaleRequest {
  final HttpClient httpAdapter;

  RemoteLoadOpenSaleRequest({
    required this.httpAdapter,
  });

  @override
  Future<List<SaleRequestModel>> load({
    required bool isConsiderDelivered,
  }) async {
    final url = EnterpriseBuilder.entity!.url;
    final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;
    int considerDelivered = isConsiderDelivered ? 1 : 0;

    final response = await httpAdapter.request(
      url:
          "$url/api/apiSaleRequest/GetAll?_enterpriseId=$enterpriseId&isConsiderDelivered=$considerDelivered",
      method: "get",
    );

    return (response as List).map((e) => SaleRequestModel.fromJson(e)).toList();
  }
}
