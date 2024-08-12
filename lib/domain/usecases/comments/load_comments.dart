import '../../entities/entities.dart';

abstract class LoadComments {
  Future<List<CommentsEntity>> load(
    List<int> productsPackingInternalCodesOnErp,
  );
}
