import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadPrintedProducts implements LoadPrintedProducts {
  final HttpClient httpAdapter;

  RemoteLoadPrintedProducts({
    required this.httpAdapter,
  });

  @override
  Future<PrintedEntity?> load({
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
      if (printedProducts == null) return null;

      final printedEntity =
          PrintedProductsModel.fromJson(printedProducts).toEntity();
      final allProducts = _insertChildsInFathers(printedEntity);
      printedEntity.Products.removeRange(0, printedEntity.Products.length);
      printedEntity.Products.addAll(allProducts);

      return printedEntity;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  List<PrintedProductsEntity> _insertChildsInFathers(PrintedEntity printed) {
    final fathers =
        printed.Products.where((e) => e.ProductIsFatherComposition == true)
            .toList();

    final childs = printed.Products.where(
      (e) => e.SaleRequestProductIdOfFather != null,
    ).toList();

    for (var father in fathers) {
      final childsOfFather = childs.where(
          (e) => e.SaleRequestProductIdOfFather == father.SaleRequestProductId);
      father.childs.addAll(childsOfFather);
    }

    final notComposition =
        printed.Products.where((e) => e.ProductIsFatherComposition == false)
            .toList()
            .where(
              (x) => x.SaleRequestProductIdOfFather == null,
            )
            .toList();

    return [
      ...fathers,
      ...notComposition,
    ];
  }
}
