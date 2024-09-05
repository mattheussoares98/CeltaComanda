import 'dart:convert';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/payment/payment.dart';
import '../../../infra/helpers/helperts.dart';
import '../../database/database.dart';

class LocalAlreadyPaid implements AlreadyPaid {
  final HiveStorage hiveStorage;

  LocalAlreadyPaid({required this.hiveStorage});

  @override
  Future<bool> verify() async {
    try {
      final value = await hiveStorage.get(CacheKeys.alreadyPaid.name);
      if (value == null) {
        return false;
      } else {
        final bool alreadyPaid = jsonDecode(value);

        return alreadyPaid;
      }
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> update(bool newValue) async {
    try {
      await hiveStorage.delete(CacheKeys.alreadyPaid.name);
      await hiveStorage.put(CacheKeys.alreadyPaid.name, newValue);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
