import '../../../data/models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/entities/sale_request_printed_products_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadSaleRequestPrintedProducts implements LoadSaleRequestPrintedProducts {
  final HttpClient httpAdapter;

  RemoteLoadSaleRequestPrintedProducts({
    required this.httpAdapter,
  });

  @override
  Future<SaleRequestPrintedProductsEntity?> load({
    required String url,
    required int enterpriseId,
    required String commandNumber,
  }) async {
    try {
      final saleRequestPrintedProducts = await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/GetTemp?_enterpriseId=$enterpriseId&_personalizedCode=$commandNumber&_considerUsing=false",
        method: "get",
      );
      if (saleRequestPrintedProducts == null) throw Error();

      // return SaleRequestModel.fromJson(saleRequestPrintedProducts).toEntity();
    } catch (error) {
      throw DomainError.commandNotAvailable;
    }
  }
}
