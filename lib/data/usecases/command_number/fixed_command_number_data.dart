import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocaFixedCommandNumberData implements FixedCommandNumberData {
  final HiveStorage hiveStorage;

  LocaFixedCommandNumberData({required this.hiveStorage});

  @override
  Future<bool> load() async {
    try {
      final json = await hiveStorage.get(
        CacheKeys.useFixedCommandNumber.name,
      );
      if (json != null) {
        return json["useFixedCommandNumber"];
      } else {
        return false;
      }
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  @override
  Future<void> update(bool use) async {
    try {
      await hiveStorage.put(
        CacheKeys.useFixedCommandNumber.name,
        {"useFixedCommandNumber": use},
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
