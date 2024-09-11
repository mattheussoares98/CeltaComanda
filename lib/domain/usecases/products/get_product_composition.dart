import '../../../domain/entities/entities.dart';

abstract class GetProductComposition {
  Future<List<ProductCompositionEntity>> getFathers({
    required int internalCodeOnErp,
  });

  Future<List<ProductCompositionEntity>> getChildsOfFather({
    required int internalCodeOnErp,
    required List<ProductCompositionEntity> fathers,
  });
}
