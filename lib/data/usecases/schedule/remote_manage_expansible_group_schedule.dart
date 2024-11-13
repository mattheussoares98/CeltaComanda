import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteManageExpansibleGroupSchedule
    implements ManageExpansibleGroupSchedule {
  final HttpClient httpAdapter;

  RemoteManageExpansibleGroupSchedule({required this.httpAdapter});

  @override
  Future<void> delete(int expansibleGroupId) async {
    try {
      final url = EnterpriseDataBuilder.enterpriseDataEntity!.url;
      final enterpriseId =
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId;
      await httpAdapter.request(
        url:
            "$url/api/APIGroups/DeleteExpansibleGroupSchedule?enterpriseId=$enterpriseId&expansibleGroupId=$expansibleGroupId",
        method: "delete",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<List<ExpansibleGroupScheduleEntity>> get(int expansibleGroupId) async {
    try {
      final url = EnterpriseDataBuilder.enterpriseDataEntity!.url;

      final result = await httpAdapter.request(
        url:
            "$url/api/APIGroups/GetExpansibleGroupSchedules?expansibleGroupId=$expansibleGroupId",
        method: "get",
      );

      if (result == null) {
        throw Exception();
      }

      return [];
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> insertUpdate(ExpansibleGroupScheduleEntity entity) async {
    try {
      final url = EnterpriseDataBuilder.enterpriseDataEntity!.url;
      final body = ExpansibleGroupScheduleModel.fromEntity(entity).toJson();

      await httpAdapter.request(
        url: "$url/api/APIGroups/InsertUpdateExpansibleGroupSchedule",
        method: "post",
        body: body,
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
