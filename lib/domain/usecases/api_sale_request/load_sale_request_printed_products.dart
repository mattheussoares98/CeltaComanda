import '../../entities/entities.dart';

abstract class LoadSaleRequestPrintedProducts {
  Future<SaleRequestPrintedProductsEntity?> load({
    required String url,
    required int enterpriseId,
    required String commandNumber,
  });
}
