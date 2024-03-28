import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:faker/faker.dart';

class ParamsFactory {
  static AddAccountParams makeAddAccount() => AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password());

  static AuthenticationParams makeAuthentication() => AuthenticationParams(
        user: faker.person.name(),
        password: faker.internet.password(),
      );
}
