import '../../../ui/pages/pages.dart';

abstract class MenuDatabaseManagement {
  Future<List<LoadedMenuViewModel>> load();
  Future<void> save(
    List<LoadedMenuViewModel> menu,
  );
}
