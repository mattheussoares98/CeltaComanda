import '../../entities/entities.dart';

abstract class LoadExpansibleGroupsByProductsCodes {
  Future<List<CommentsEntity>> load({
    required List<int> productsPackingInternalCodesOnErp,
    required int expansibleGroupType,
  });
}
