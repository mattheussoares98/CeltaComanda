import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';

abstract class GetProductComposition {
  Future<List<ProductCompositionEntity>> getFathers({
    required int internalCodeOnErp,
  });

  Future<List<ProductCompositionViewModel>> getChildsOfFather({
    required int internalCodeOnErp,
    required List<ProductCompositionEntity> fathers,
  });
}
