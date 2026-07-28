import 'package:flutter/foundation.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';

class ConcentratorPdvRegistration
    with ErrorHandling
    implements PdvRegistration {
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
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<void> setPdvRegister({
    required int pdvId,
    required String imeiOrWindowsId,
    required String versionNumber,
    required String ip,
    required bool isUsing,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity!.concentradorUrl;

      final version =
          "$versionNumber = ${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";

      await httpAdapter.request(
        url:
            '$url/api/APIPdvs/SetPdvRegister?pdvId=$pdvId&isUsing=$isUsing&ipAddress=$ip&macAddress=$imeiOrWindowsId&versionNumber=$version',
        method: "post",
        headers: headers,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<PdvEntity?> getById(int pdvId) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity!.concentradorUrl;

      final response = await httpAdapter.request(
        url: '$url/api/APIPdvs/GetById?id=$pdvId',
        method: "get",
        headers: headers,
      );

      if (response == null) {
        return null;
      } else {
        return PdvModel.fromJson(response).toEntity();
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updatePdvRegister({
    required PdvEntity entity,
    required String versionNumber,
  }) async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity!.concentradorUrl;

      final version =
          "$versionNumber = ${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}";
      // final pdvId = entity.PdvId!;
      // final imeiOrWindowsId = entity.MacAddress!;

      final newEntity = PdvEntity(
        VersionNumber: version,
        PdvId: entity.PdvId,
        PdvNumber: entity.PdvNumber,
        IPAddress: entity.IPAddress,
        EnterpriseId: entity.EnterpriseId,
        MacAddress: entity.MacAddress,
        ParametersJSON: entity.ParametersJSON,
        UrlSATSharing: entity.UrlSATSharing,
        SATHabilitationType: entity.SATHabilitationType,
        SATHabilitationTypeString: entity.SATHabilitationTypeString,
        SATStatus: entity.SATStatus,
        SATStatusDateHourLastUpdate: entity.SATStatusDateHourLastUpdate,
        SATStatusDateHourLastUpdateString:
            entity.SATStatusDateHourLastUpdateString,
        IsUsing: entity.IsUsing,
      );

      final body = PdvModel.fromEntity(newEntity).toJson();

      await httpAdapter.request(
        url: '$url/api/APIPdvs/Update',
        method: "put",
        headers: headers,
        body: body,
      );
    } catch (e) {
      debugPrint(e.toString());
      //tudo bem, depois atualiza o registro. Já foi certificado de que é o mesmo dispositivo
    }
  }

  @override
  Future<List<PdvEntity>> getByEnterpriseId() async {
    try {
      var headers = {'Authorization': 'Basic MASTERPDV:PASSWORD'};

      final url = EnterpriseBuilder.entity!.concentradorUrl;
      final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;

      final response = await httpAdapter.request(
        url: '$url/api/APIPdvs/GetByEnterprise?enterpriseId=$enterpriseId',
        method: "get",
        headers: headers,
      );

      if (response.isEmpty) {
        throw DomainError.dontHaveUnusedPdvs;
      } else if (response == null) {
        throw DomainError.unexpected;
      } else {
        return (response as List)
            .map((e) => PdvModel.fromJson(e).toEntity())
            .toList();
      }
    } on DomainError catch (e) {
      treatError(e);
    }
  }
}
