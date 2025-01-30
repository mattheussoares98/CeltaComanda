import '../../../ui/pages/pages.dart';

abstract class MenuDatabaseManagement {
  Future<List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>> load();
  Future<void> save(
    List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> menu,
  );
}
