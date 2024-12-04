import 'package:flutter/material.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../database/database.dart';

class LocalUpdatedAllImages implements UpdatedAllImages {
  final HiveStorage hiveStorage;

  LocalUpdatedAllImages({required this.hiveStorage});

  @override
  Future<DateTime?> getLastDate() async {
    try {
      return await hiveStorage.get(
        CacheKeys.updatedAllImages.name,
      );
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> updateLastDate(DateTime date) async {
    try {
      await hiveStorage.put(
        CacheKeys.updatedAllImages.name,
        date,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
