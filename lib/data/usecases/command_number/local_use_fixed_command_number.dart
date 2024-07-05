import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import '../../cache/cache.dart';

class LocalUseFixedCommandNumber implements UseFixedCommandNumber {
  final HiveStorage hiveStorage;

  LocalUseFixedCommandNumber({required this.hiveStorage});

  @override
  Future<bool> load() async {
    return false;
  }

  @override
  Future<void> update(bool use) async {}
}
