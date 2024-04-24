import '../../entities/entities.dart';

abstract class LoadPrintedProducts {
  Future<PrintedProductsEntity?> load({
    required String url,
    required int enterpriseId,
    required int commandNumber,
  });
}
