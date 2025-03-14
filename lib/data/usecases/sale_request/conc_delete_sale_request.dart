import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class ConcDeleteSaleRequest implements DeleteSaleRequest {
  final HttpClient httpAdapter;

  ConcDeleteSaleRequest({required this.httpAdapter});

  @override
  Future<void> delete(int saleRequestId) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};
      final concentradorUrl = EnterpriseBuilder.entity?.concentradorUrl;

      final response = await httpAdapter.request(
        url: "$concentradorUrl/api/APISaleRequest/Delete?id=$saleRequestId",
        method: "delete",
        headers: headers,
      );

      if (response.toString().toLowerCase() != "ok") {
        throw Exception();
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
