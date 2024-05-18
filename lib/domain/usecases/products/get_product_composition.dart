import 'package:clean_celta_mobile/domain/entities/entities.dart';

abstract class GetProductComposition {
  Future<List<ProductCompositionEntity>> getProducts({
    required String url,
    required int enterpriseId,
    required int internalCodeOnERPCodeFather,
  });
}
