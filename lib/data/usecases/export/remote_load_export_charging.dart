import 'package:clean_celta_mobile/data/models/export_charging_model.dart';
import 'package:flutter/material.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadExportCharging implements LoadExportCharging {
  final HttpClient httpClient;

  RemoteLoadExportCharging({required this.httpClient});

  @override
  Future<ExportChargingModel> loadExportsCharging({
    required String pdvNumber,
  }) async {
    try {
      final url = EnterpriseBuilder.entity?.concentradorUrl;
      final enterpriseId = EnterpriseBuilder.entity?.enterpriseId;

      final response = await httpClient.request(
        url:
            '$url/api/APIExport/GetAll?pdv=$pdvNumber&enterpriseId=$enterpriseId',
        method: 'get',
        headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
      );

      if (response == null) {
        throw Exception();
      } else {
        debugPrint(response);
        // return ExportChargingModel.fromJson(response);
        return ExportChargingModel(
          lastUpdateImages: DateTime.now(),
          lastUpdateProducts: DateTime.now(),
        );
      }
    } catch (e) {
      throw Exception();
    }
  }
}
