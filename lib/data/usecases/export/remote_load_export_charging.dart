import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadExportCharging implements LoadExportCharging {
  final HttpClient httpClient;

  RemoteLoadExportCharging({required this.httpClient});

  @override
  Future<List<ExportChargingEntity>> load({
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
        // return ExportChargingModel.fromJson(response);
        return (response as List)
            .map((e) => ExportChargingModel.fromJson(e).toEntity())
            .toList();
      }
    } catch (e) {
      throw Exception();
    }
  }
}
