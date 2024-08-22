import 'dart:convert';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../database/database.dart';

class LocalPaidInformations implements PaidInformations {
  final HiveStorage hiveStorage;

  LocalPaidInformations({required this.hiveStorage});

  @override
  Future<bool> getAlreadyPaid() async {
    try {
      final value = await hiveStorage.get(CacheKeys.paidInformations.name);
      if (value == null) {
        return false;
      } else {
        final bool paid = jsonDecode(value);

        return paid;
      }
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
