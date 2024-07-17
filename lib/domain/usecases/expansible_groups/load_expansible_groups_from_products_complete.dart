import '../../../domain/entities/entities.dart';

abstract class LoadExpansibleGroupsFromProductsComplete {
  Future<List<ExpansibleGroupFromProductCompleteEntity>> load();
}
