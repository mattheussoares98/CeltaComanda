import 'package:clean_celta_mobile/main/builders/builders.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/products/products.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadProducts implements LoadProducts {
  final HttpClient httpAdapter;
  final String url;

  RemoteLoadProducts({
    required this.httpAdapter,
    required this.url,
  });

  @override
  Future<List<ProductEntity>> load(int? expansibleGroupId) async {
    try {
      if (expansibleGroupId == null) throw DomainError.unexpected;

      String url =
          "${EnterpriseDataBuilder.enterpriseDataEntity!.url}/api/APIProduct/GetAllByGroup?_enterpriseId=${EnterpriseDataBuilder.enterpriseDataEntity!.enterpriseId}&_groupCode=$expansibleGroupId";
      final products = await httpAdapter.request(url: url, method: "get");
      if (products == null) throw Error();
      return [
        const ProductEntity(
          name: "name",
          plu: "plu",
          price: 10,
          image:
              "https://lh4.googleusercontent.com/ECbQV5RNf6RMdJQ_qE-s-9JF9lYOSTyxCYq5nCrHgcBct8ixi__prSequxRFInCxyVojmotC91hoNvrNDwOihQ1YHM5tMW_MRmDtCjOVpMbikgdiv0vqIE1PmQu9xNEA0Ke-aYjHOJAL5ec00E-2g28",
        ),
        const ProductEntity(
          name: "name",
          plu: "plu",
          price: 10,
          image: "http://teste.com.jpeg",
        ),
      ];
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
