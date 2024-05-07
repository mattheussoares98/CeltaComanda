import 'package:clean_celta_mobile/domain/entities/product_entity.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteSearchProductByCode implements SearchProductByCode {
  final HttpClient httpAdapter;

  RemoteSearchProductByCode({
    required this.httpAdapter,
  });

  @override
  Future<ProductEntity> search({
    required String url,
    required String value,
    required String enterpriseId,
  }) async {
    try {
      final response = await httpAdapter.request(
          url:
              "$url/api/APIProduct/get?_enterpriseId=$enterpriseId&_productCode=$value",
          method: "get");

      if (response == null) throw Error();

      return response.map<ProductEntity>((element) {
        return ProductModel.fromJson(element).toEntity();
      }).toList();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
