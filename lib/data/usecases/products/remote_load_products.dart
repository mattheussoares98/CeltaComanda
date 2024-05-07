import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/products/products.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/builders/builders.dart';
import '../../http/http.dart';

class RemoteLoadProducts implements LoadProducts {
  final HttpClient httpAdapter;

  RemoteLoadProducts({
    required this.httpAdapter,
  });

  @override
  Future<List<ProductEntity>> load(int? expansibleGroupId) async {
    try {
      if (expansibleGroupId == null) throw DomainError.unexpected;

      String url =
          "${EnterpriseDataBuilder.enterpriseDataEntity!.url}/api/APIProduct/GetAllByGroup?_enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}&_groupCode=$expansibleGroupId";
      final response = await httpAdapter.request(url: url, method: "get");
      if (response == null) throw Error();

      return response.map<ProductEntity>((element) {
        return ProductModel.fromJson(element).toEntity();
      }).toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
