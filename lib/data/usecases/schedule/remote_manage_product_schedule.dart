import 'package:clean_celta_mobile/domain/entities/schedule_entity.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteManageProductSchedule implements ManageProductSchedule {
  final HttpClient httpAdapter;

  RemoteManageProductSchedule({required this.httpAdapter});

  @override
  Future<void> delete(int internalCodeOnErp) async {
    try {
      final url = EnterpriseDataBuilder.enterpriseDataEntity!.url;
      final enterpriseId =
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId;
      await httpAdapter.request(
        url:
            "$url/api/APIProduct/DeleteProductSchedule?enterpriseId=$enterpriseId&internalCodeOnERP=$internalCodeOnErp",
        method: "delete",
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<List<ProductScheduleEntity>> get(int internalCodeOnErp) async {
    try {
      final url = EnterpriseDataBuilder.enterpriseDataEntity!.url;
      final enterpriseId =
          EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId;
      final result = await httpAdapter.request(
        url:
            "$url/api/APIProduct/GetProductSchedules?enterpriseId=$enterpriseId&internalCodeOnERP=$internalCodeOnErp",
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
  Future<void> insertUpdate(ProductScheduleEntity entity) async {
    try {
      final url = EnterpriseDataBuilder.enterpriseDataEntity!.url;
      final body = ProductScheduleModel.fromEntity(entity).toJson();

      await httpAdapter.request(
        url: "$url/api/APIProduct/InsertUpdateProductSchedule",
        method: "post",
        body: body,
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
