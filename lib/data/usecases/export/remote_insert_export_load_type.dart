import 'package:flutter/material.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteInsertExportLoadType implements InsertExportLoadType {
  final HttpClient httpClient;

  RemoteInsertExportLoadType({required this.httpClient});

  @override
  Future<void> insert(String loadtypeName) async {
    try {
      final url = EnterpriseBuilder.entity?.concentradorUrl;
      final enterpriseId = EnterpriseBuilder.entity?.enterpriseId;

      final response = await httpClient.request(
        url:
            '$url/api/APIExport/ExportLoadType?loadtype=$loadtypeName&loadParameter=&enterpriseId=$enterpriseId&userId=0',
        method: 'put',
        headers: {'Authorization': 'Basic MASTERPDV:PASSWORD'},
      );

      debugPrint(response.toString());
    } catch (e) {
      rethrow;
    }
  }
}
