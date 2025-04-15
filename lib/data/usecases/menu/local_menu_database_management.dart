import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../../main/builders/builders.dart';
import '../../../ui/pages/pages.dart';
import '../../database/database.dart';
import '../../models/models.dart';

class LocalMenuDatabaseManagement implements MenuDatabaseManagement {
  final HiveStorage hiveStorage;

  LocalMenuDatabaseManagement({required this.hiveStorage});

  @override
  Future<List<LoadedMenuViewModel>> load() async {
    try {
      final allMenus = await _getAllMenus();

      final enterpriseMenu = allMenus
              .where((e) =>
                  e.enterpriseName == EnterpriseBuilder.entity!.enterpriseName)
              .firstOrNull
              ?.menu ??
          [];
      return enterpriseMenu;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> save(List<LoadedMenuViewModel> menu) async {
    try {
      final allMenus = await _getAllMenus();

      int indexMenuInDatabase = allMenus.indexWhere((element) =>
          element.enterpriseName == EnterpriseBuilder.entity!.enterpriseName);

      if (indexMenuInDatabase != -1) {
        allMenus[indexMenuInDatabase] = LoadedMenuModel(
          menu: menu,
          enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        );
      } else {
        allMenus.add(LoadedMenuModel(
          menu: menu,
          enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        ));
      }

      await hiveStorage.delete(CacheKeys.menu.name);
      await hiveStorage.put(
        CacheKeys.menu.name,
        allMenus.map((e) => jsonEncode(e.toJson())).toList(),
      );
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<LoadedMenuModel>> _getAllMenus() async {
    var response = await hiveStorage.get(CacheKeys.menu.name);

    try {
      //new way
      final value = (response as List)
          .map((e) => LoadedMenuModel.fromJson(jsonDecode(e)))
          .toList();

      debugPrint("restored menu in new way");
      return value;
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      //old way
      debugPrint("old");
      final value = [
        LoadedMenuModel(
          menu: (jsonDecode(response) as List)
              .map((e) => LoadedMenuViewModel.fromJson(e))
              .toList(),
          enterpriseName: EnterpriseBuilder.entity!.enterpriseName,
        ),
      ];
      debugPrint("Restored menu in old way");
      return value;
    } catch (e) {
      debugPrint("Throws to restore menu in old way");
      return [];
    }
  }
}
