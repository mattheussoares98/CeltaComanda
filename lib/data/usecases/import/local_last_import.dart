import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';
import '../../models/models.dart';

class LocalLastImport implements LastImport {
  final HiveStorage hiveStorage;

  LocalLastImport({required this.hiveStorage});
  @override
  Future<LastImportEntity?> load() async {
    try {
      final lastImport = await hiveStorage.get(CacheKeys.lastImport.name);

      if (lastImport == null) {
        return null;
      } else {
        return LastImportModel.fromJson(lastImport).toEntity();
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(List<LoadTypeEnum> typesToUpdate) async {
    try {
      final previousDate = await hiveStorage.get(CacheKeys.lastImport.name);

      LastImportModel? lastImportEntity =
          previousDate == null ? null : LastImportModel.fromJson(previousDate);

      final newEntity = LastImportEntity(
        products: typesToUpdate.contains(LoadTypeEnum.products)
            ? DateTime.now()
            : lastImportEntity?.products,
        images: typesToUpdate.contains(LoadTypeEnum.images)
            ? DateTime.now()
            : lastImportEntity?.images,
      );

      await hiveStorage.delete(CacheKeys.lastImport.name);
      await hiveStorage.put(
        CacheKeys.lastImport.name,
        LastImportModel.fromEntity(newEntity).toJson(),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
