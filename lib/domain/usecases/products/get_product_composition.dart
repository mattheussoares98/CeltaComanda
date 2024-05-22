import 'package:clean_celta_mobile/domain/entities/entities.dart';

import '../../../ui/pages/pages.dart';

abstract class GetProductComposition {
  Future<List<ProductCompositionEntity>> getFathers({
    required String url,
    required int enterpriseId,
    required int internalCodeOnErp,
  });

  Future<List<ProductCompositionViewModel>> getChildsOfFather({
    required String url,
    required int enterpriseId,
    required int internalCodeOnErp,
    required List<ProductCompositionEntity> fathers,
  });
}
