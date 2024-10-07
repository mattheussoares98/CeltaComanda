import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';

import '../../database/database.dart';
import '../../models/customer/customer.dart';

class LocalCovenantAuthorizationIsPendant
    implements CovenantAuthorizationIsPendant {
  final HiveStorage hiveStorage;

  LocalCovenantAuthorizationIsPendant({required this.hiveStorage});

  @override
  Future<AuthorizationPendingModel?> get() async {
    try {
      final value =
          await hiveStorage.get(CacheKeys.covenantAuthorizationPendant.name);
      return value;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> update(AuthorizationPendingModel? model) async {
    try {
      await hiveStorage.delete(CacheKeys.covenantAuthorizationPendant.name);
      await hiveStorage.put(
        CacheKeys.covenantAuthorizationPendant.name,
        model?.toJson(),
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
