import 'package:clean_celta_mobile/domain/entities/entities.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../infra/helpers/helperts.dart';
import '../../cache/cache.dart';

class LocalLoadLoginData implements LoadLoginData {
  final CacheStorage cacheStorage;

  LocalLoadLoginData({required this.cacheStorage});

  @override
  Future<LoginDataEntity?> load() async {
    try {
      LoginDataEntity? loginData = await cacheStorage.get(CacheKeys.loginData.name);
      if (loginData == null) throw Error();
      return loginData;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
