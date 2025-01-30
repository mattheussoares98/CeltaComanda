import 'dart:convert';

import 'package:clean_celta_mobile/ui/pages/menus/expansible_groups_view_model.dart';

import 'package:clean_celta_mobile/ui/pages/products/products_view_model.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';

class LocalMenuDatabaseManagement implements MenuDatabaseManagement {
  final HiveStorage hiveStorage;

  LocalMenuDatabaseManagement({required this.hiveStorage});

  @override
  Future<List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>>>
      load() async {
    try {
      final response = await hiveStorage.get(CacheKeys.menu.name);

      final menu = jsonDecode(response);
      return menu;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> save(
    List<Map<ExpansibleGroupsViewModel, List<ProductsViewModel>>> menu,
  ) async {
    try {
      await hiveStorage.delete(CacheKeys.menu.name);
      final encodedMenu = menu
          .map((e) => {
                e.keys.first.toJson(): e.values.first.map((e) => e.toJson()),
              })
          .toList();
      await hiveStorage.put(CacheKeys.menu.name, encodedMenu.toString());
    } catch (e) {
      throw Exception();
    }
  }
}
