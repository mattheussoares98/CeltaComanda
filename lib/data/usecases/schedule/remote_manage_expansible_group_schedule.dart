import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';

class RemoteManageExpansibleGroupSchedule
    with ErrorHandling
    implements ManageExpansibleGroupSchedule {
  final HttpClient httpAdapter;

  RemoteManageExpansibleGroupSchedule({required this.httpAdapter});

  @override
  Future<void> delete(int expansibleGroupId) async {
    try {
      final url = EnterpriseBuilder.entity!.url;
      final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;
      await httpAdapter.request(
        url:
            "$url/api/APIGroups/DeleteExpansibleGroupSchedule?enterpriseId=$enterpriseId&expansibleGroupId=$expansibleGroupId",
        method: "delete",
      );
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<List<ExpansibleGroupScheduleEntity>> get(int expansibleGroupId) async {
    try {
      final url = EnterpriseBuilder.entity!.url;

      final result = await httpAdapter.request(
        url:
            "$url/api/APIGroups/GetExpansibleGroupSchedules?expansibleGroupId=$expansibleGroupId",
        method: "get",
      );

      if (result == null) {
        throw Exception();
      }

      return [];
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<void> insertUpdate(ExpansibleGroupScheduleEntity entity) async {
    try {
      final url = EnterpriseBuilder.entity!.url;
      final body = ExpansibleGroupScheduleModel.fromEntity(entity).toJson();

      await httpAdapter.request(
        url: "$url/api/APIGroups/InsertUpdateExpansibleGroupSchedule",
        method: "post",
        body: body,
      );
    } catch (e) {
      treatError(e);
    }
  }
}
