import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';

class RemoteManageProductSchedule
    with ErrorHandling
    implements ManageProductSchedule {
  final HttpClient httpAdapter;

  RemoteManageProductSchedule({required this.httpAdapter});

  @override
  Future<void> delete(int internalCodeOnErp) async {
    try {
      final url = EnterpriseBuilder.entity!.url;
      final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;
      await httpAdapter.request(
        url:
            "$url/api/APIProduct/DeleteProductSchedule?enterpriseId=$enterpriseId&internalCodeOnERP=$internalCodeOnErp",
        method: "delete",
      );
    } catch (e) {
      treatError(e);
    }
  }

  @override
  Future<List<ProductScheduleEntity>> get(int internalCodeOnErp) async {
    try {
      final url = EnterpriseBuilder.entity!.url;
      final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;
      final result = await httpAdapter.request(
        url:
            "$url/api/APIProduct/GetProductSchedules?enterpriseId=$enterpriseId&internalCodeOnERP=$internalCodeOnErp",
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
  Future<void> insertUpdate(ProductScheduleEntity entity) async {
    try {
      final url = EnterpriseBuilder.entity!.url;
      final body = ProductScheduleModel.fromEntity(entity).toJson();

      await httpAdapter.request(
        url: "$url/api/APIProduct/InsertUpdateProductSchedule",
        method: "post",
        body: body,
      );
    } catch (e) {
      treatError(e);
    }
  }
}
