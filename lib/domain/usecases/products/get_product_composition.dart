import 'package:clean_celta_mobile/domain/entities/entities.dart';

abstract class GetProductComposition {
  Future<ProductCompositionEntity> getProducts({
    required String url,
    required int enterpriseId,
    required int internalCodeOnERPCodeFather,
  });
}
