import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';

import '../../database/database.dart';

class LocalConfirmedCartProducts implements ConfirmedCartProducts {
  final HiveStorage hiveStorage;

  LocalConfirmedCartProducts({required this.hiveStorage});

  @override
  Future<bool> isConfirmed() async {
    try {
      final value =
          await hiveStorage.get(CacheKeys.updatedSaleRequestTemp.name);
      return value == true;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> updateValue(bool value) async {
    try {
      await hiveStorage.delete(CacheKeys.updatedSaleRequestTemp.name);
      await hiveStorage.put(CacheKeys.updatedSaleRequestTemp.name, value);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
