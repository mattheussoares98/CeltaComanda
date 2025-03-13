import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helpers.dart';
import '../../database/database.dart';

class LocalCouponFiscalNumber implements CouponFiscalNumber {
  final HiveStorage hiveStorage;

  LocalCouponFiscalNumber({required this.hiveStorage});

  @override
  Future<int> loadLastNumber() async {
    try {
      final couponNumber =
          await hiveStorage.get(CacheKeys.couponFiscalNumber.name);
      if (couponNumber == null) {
        return 1;
      }

      return couponNumber;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> save(int number) async {
    try {
      await hiveStorage.delete(CacheKeys.couponFiscalNumber.name);
      await hiveStorage.put(CacheKeys.couponFiscalNumber.name, number);
    } catch (e) {
      rethrow;
    }
  }
}
