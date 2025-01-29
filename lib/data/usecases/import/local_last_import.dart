import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
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
  Future<void> save(LastImportEntity? entity) async {
    try {
      await hiveStorage.delete(CacheKeys.lastImport.name);

      if (entity != null) {
        await hiveStorage.put(
          CacheKeys.lastImport.name,
          LastImportModel.fromEntity(entity).toJson(),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
