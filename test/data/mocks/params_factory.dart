import 'package:clean_celta_mobile/data/usecases/login_data/login_data.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:faker/faker.dart';

import 'cache_storage_spy.dart';

class ParamsFactory {
  static AuthenticationParams makeAuthentication() => AuthenticationParams(
        user: faker.person.name(),
        password: faker.internet.password(),
        url: faker.internet.httpUrl(),
      );

  static SaveLoginData makeLoginData() => LocalSaveLoginData(
        cacheStorage: CacheStorageSpy(),
      );
}
