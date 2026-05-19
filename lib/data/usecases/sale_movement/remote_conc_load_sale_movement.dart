import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteConcLoadSaleMovement implements ConcLoadSaleMovement {
  final HttpClient httpAdapter;

  RemoteConcLoadSaleMovement({required this.httpAdapter});

  @override
  Future<List<SaleMovementConcentratorEntity>> load({
    required String date,
    String? concentratorUrl,
    int? enterpriseId,
    int? concentratorPort,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final dateTime = DateTime.parse(date);
      final String formatedDate =
          formatDate(dateTime, [yyyy, '-', mm, '-', dd]);

      final applied = concentratorUrl != null && concentratorPort != null
          ? "$concentratorUrl:$concentratorPort"
          : EnterpriseBuilder.entity!.concentradorUrl;
      final appliedEnterpriseId =
          enterpriseId ?? EnterpriseBuilder.entity!.enterpriseId;

      final url =
          "$applied/api/APISaleMovement/Search?enterpriseId=$appliedEnterpriseId&date=$formatedDate&onlyCancelled=false";
      final response = await httpAdapter.request(
        url: url,
        method: "get",
        headers: headers,
      );

      return (response as List?)
              ?.map((e) => SaleMovementConcentratorModel.fromJson(e).toEntity())
              .toList() ??
          [];
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<SaleMovementConcentratorEntity>?> loadDeliverySales({
    required String concentratorUrl,
    required int enterpriseId,
    required int concentratorPort,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url =
          "$concentratorUrl:$concentratorPort/api/APISaleMovement/GetSaleMovementDeliveryToPrint?enterpriseId=$enterpriseId";
      final response = await httpAdapter.request(
        url: url,
        method: "get",
        headers: headers,
      );

      return (response as List?)
          ?.map((e) => SaleMovementConcentratorModel.fromJson(e).toEntity())
          .toList();
    } catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }
}
