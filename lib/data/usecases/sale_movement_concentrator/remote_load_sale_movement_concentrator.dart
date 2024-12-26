import 'dart:convert';

import 'package:date_format/date_format.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSaleMovementConcentrator
    implements LoadSaleMovementConcentrator {
  final HttpClient httpAdapter;

  RemoteLoadSaleMovementConcentrator({required this.httpAdapter});

  @override
  Future<List<SaleMovementConcentratorEntity>> load({
    required String date,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final dateTime = DateTime.parse(date);
      final String formatedDate =
          formatDate(dateTime, [yyyy, '-', mm, '-', dd]);

      final url =
          "${EnterpriseBuilder.entity!.concentradorUrl}/api/APISaleMovement/Search?enterpriseId=${EnterpriseBuilder.entity!.enterpriseId}&d$formatedDate&onlyCancelled=false";
      final response = await httpAdapter.request(
        url: url,
        method: "put",
        headers: headers,
      );
      if (response == null) {
        throw Error();
      }

      return (json.decode(response) as List)
          .map((e) => SaleMovementConcentratorModel.fromJson(e).toEntity())
          .toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
