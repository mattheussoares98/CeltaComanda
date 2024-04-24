import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/entities/sale_request_printed_products_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadPrintedProducts
    implements LoadPrintedProducts {
  final HttpClient httpAdapter;

  RemoteLoadPrintedProducts({
    required this.httpAdapter,
  });

  @override
  Future<PrintedProductsEntity?> load({
    required String url,
    required int enterpriseId,
    required int commandNumber,
  }) async {
    try {
      final printedProducts = await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/Get?_enterpriseId=$enterpriseId&_personalizedCode=$commandNumber&_considerUsing=false",
        method: "get",
      );
      if (printedProducts == null) throw Error();

      return PrintedProductsModel.fromJson(
              printedProducts)
          .toEntity();
    } catch (error) {
      throw DomainError.commandNotAvailable;
    }
  }
}
