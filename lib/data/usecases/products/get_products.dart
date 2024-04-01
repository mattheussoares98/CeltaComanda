import 'package:clean_celta_mobile/data/http/http.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RemoteGetProducts implements GetProducts {
  final HttpClient httpAdapter;

  RemoteGetProducts({required this.httpAdapter});

  @override
  Future<List<ProductEntity>?> getProducts() async {
    try {
      final products = await httpAdapter.request(url: "url", method: "get");
      if (products == null) throw Error();
      return const [
        ProductEntity(name: "name", plu: "plu", price: 10),
      ];
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
