import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:faker/faker.dart';

class ParamsFactory {
  static AuthenticationParams makeAuthentication() => AuthenticationParams(
        user: faker.person.name(),
        password: faker.internet.password(),
      );
}
