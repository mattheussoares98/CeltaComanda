import '../../../main/builders/builders.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteLoadPrintedProducts
    with ErrorHandling
    implements LoadPrintedProducts {
  final HttpClient httpAdapter;

  RemoteLoadPrintedProducts({
    required this.httpAdapter,
  });

  @override
  Future<PrintedEntity?> load({
    required int commandNumber,
  }) async {
    try {
      final enterpriseId = EnterpriseBuilder.entity!.enterpriseId;
      final url = EnterpriseBuilder.entity!.url;

      final printedProducts = await httpAdapter.request(
        url:
            "$url/api/apiSaleRequest/Get?_enterpriseId=$enterpriseId&_personalizedCode=$commandNumber&_considerUsing=false",
        method: "get",
      );
      if (printedProducts == null) return null;

      final printedEntity = PrintedModel.fromJson(printedProducts).toEntity();
      final allProducts = _insertChildsInFathers(printedEntity);
      printedEntity.Products.removeRange(0, printedEntity.Products.length);
      printedEntity.Products.addAll(allProducts);

      return printedEntity;
    } catch (e) {
      treatError(e);
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
