import 'dart:convert';

import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../../ui/pages/pages.dart';
import '../../database/database.dart';

class LocalMenuDatabaseManagement implements MenuDatabaseManagement {
  final HiveStorage hiveStorage;

  LocalMenuDatabaseManagement({required this.hiveStorage});

  @override
  Future<List<LoadedMenuViewModel>> load() async {
    try {
      final response = await hiveStorage.get(CacheKeys.menu.name);

      final menu = (jsonDecode(response) as List)
          .map((e) => LoadedMenuViewModel.fromJson(e))
          .toList();
      return menu;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> save(List<LoadedMenuViewModel> menu) async {
    try {
      await hiveStorage.delete(CacheKeys.menu.name);

      await hiveStorage.put(CacheKeys.menu.name,
          jsonEncode(menu.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw Exception();
    }
  }
}
