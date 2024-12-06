import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class ConcentratorPdvRegistration implements PdvRegistration {
  final HttpClient httpAdapter;

  ConcentratorPdvRegistration({required this.httpAdapter});

  @override
  Future<List<PdvEntity>> getPdvNotUsing() async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity!.concentradorUrl;
      final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;

      final response = await httpAdapter.request(
        url: '$url/api/APIPdvs/GetPdvNotUsing?enterpriseId=$enterpriseId',
        method: "get",
        headers: headers,
      );

      if (response.isEmpty) {
        throw DomainError.dontHaveUnusedPdvs;
      } else if (response == null) {
        throw DomainError.unexpected;
      } else {
        return response
            .map((e) => PdvModel.fromJson(e).toEntity())
            .toList()
            .cast<PdvEntity>();
      }
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.dontHaveUnusedPdvs:
          throw DomainError.dontHaveUnusedPdvs;
        default:
          throw DomainError.unexpected;
      }
    }
  }

  @override
  Future<void> setPdvRegister({
    required int pdvId,
    required String imeiOrWindowsId,
    required String versionNumber,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity!.concentradorUrl;

      final version =
          "$versionNumber = ${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";

      await httpAdapter.request(
        url:
            '$url/api/APIPdvs/SetPdvRegister?pdvId=$pdvId&isUsing=true&ipAddress=127.0.0.1&macAddress=$imeiOrWindowsId&versionNumber=$version',
        method: "post",
        headers: headers,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<PdvEntity?> getById(int pdvId) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity!.concentradorUrl;

      final response = await httpAdapter.request(
        url: '$url/api/APIPdvs/GetById?id=$pdvId',
        method: "post",
        headers: headers,
      );

      if (response == null) {
        return null;
      } else {
        return PdvModel.fromJson(response).toEntity();
      }
    } catch (error) {
      return null;
    }
  }
}
