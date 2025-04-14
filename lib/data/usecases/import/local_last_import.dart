import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../../main/builders/builders.dart';
import '../../database/database.dart';
import '../../models/models.dart';

class LocalLastImport implements LastImport {
  final HiveStorage hiveStorage;

  LocalLastImport({required this.hiveStorage});
  @override
  Future<LastImportEntity?> load() async {
    try {
      final lastImports = await hiveStorage.get(CacheKeys.lastImport.name);

      if (lastImports == null) {
        return null;
      } else if (lastImports is List) {
        return lastImports
            .map((e) => LastImportModel.fromJson(e).toEntity())
            .toList()
            .where((e) =>
                e.enterpriseName == EnterpriseBuilder.entity?.enterpriseName)
            .firstOrNull;
      } else {
        return LastImportModel.fromJson(lastImports).toEntity();
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(List<LoadTypeEnum> typesToUpdate) async {
    try {
      final databaseImports = await hiveStorage.get(CacheKeys.lastImport.name);
      late List<LastImportModel> allDatabaseImports;
      if (databaseImports == null) {
        allDatabaseImports = [];
      } else if (databaseImports is List) {
        allDatabaseImports =
            databaseImports.map((e) => LastImportModel.fromJson(e)).toList();
      } else {
        allDatabaseImports = [LastImportModel.fromJson(databaseImports)];
      }

      LastImportModel? lastImportEntity = allDatabaseImports
          .where((element) =>
              element.enterpriseName ==
              EnterpriseBuilder.entity?.enterpriseName)
          .firstOrNull;

      final newEntity = LastImportEntity(
        products: typesToUpdate.contains(LoadTypeEnum.products)
            ? DateTime.now()
            : lastImportEntity?.products,
        images: typesToUpdate.contains(LoadTypeEnum.images)
            ? DateTime.now()
            : lastImportEntity?.images,
        users: typesToUpdate.contains(LoadTypeEnum.users)
            ? DateTime.now()
            : lastImportEntity?.users,
        enterprise: typesToUpdate.contains(LoadTypeEnum.enterprise)
            ? DateTime.now()
            : lastImportEntity?.enterprise,
        enterpriseName: EnterpriseBuilder.entity?.enterpriseName,
      );

      final index = allDatabaseImports.indexWhere(
          (e) => e.enterpriseName == EnterpriseBuilder.entity?.enterpriseName);

      if (index == -1) {
        allDatabaseImports.add(LastImportModel.fromEntity(newEntity));
      } else {
        allDatabaseImports[index] = LastImportModel.fromEntity(newEntity);
      }

      await hiveStorage.delete(CacheKeys.lastImport.name);
      await hiveStorage.put(
        CacheKeys.lastImport.name,
        allDatabaseImports.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
