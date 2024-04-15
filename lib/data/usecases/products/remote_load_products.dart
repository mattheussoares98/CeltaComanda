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
  Future<List<ProductEntity>> load() async {
    try {
      final products = await httpAdapter.request(url: "url", method: "get");
      if (products == null) throw Error();
      return [
        const ProductEntity(
          name: "name",
          plu: "plu",
          price: 10,
          image: "http://",
        ),
        const ProductEntity(
          name: "name",
          plu: "plu",
          price: 10,
          image: "http://",
        ),
      ];
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
