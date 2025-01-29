import 'package:flutter/foundation.dart';

import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';

class LocalDeleteData implements DeleteData {
  final HiveStorage hiveStorage;

  LocalDeleteData({required this.hiveStorage});

  @override
  Future<void> delete(List<CacheKeys> keys) async {
    try {
      for (var key in keys) {
        await hiveStorage.delete(key.name);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
