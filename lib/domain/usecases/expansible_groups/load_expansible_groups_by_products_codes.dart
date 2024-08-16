import '../../entities/entities.dart';

abstract class LoadExpansibleGroupsByProductsCodes {
  Future<List<ExpansibleGroupFromProductsCompleteEntity>> load({
    required List<int> productsPackingInternalCodesOnErp,
    required int expansibleGroupType,
  });
}
