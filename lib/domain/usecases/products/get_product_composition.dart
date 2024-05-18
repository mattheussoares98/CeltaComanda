import 'package:clean_celta_mobile/domain/entities/entities.dart';

abstract class GetProductComposition {
  Future<List<ProductCompositionEntity>> get({
    required String url,
    required int enterpriseId,
    required int internalCodeOnErp,
  });
}
