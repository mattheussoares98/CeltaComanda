import '../../../domain/entities/entities.dart';

abstract class LoadExpansibleGroupsFromProductsComplete {
  Future<List<ExpansibleGroupFromProductCompleteEntity>> load(
    List<int> productsPackingInternalCodesOnErp,
  );
}
