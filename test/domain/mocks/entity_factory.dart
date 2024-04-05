import 'package:clean_celta_mobile/domain/entities/entities.dart';

import 'package:faker/faker.dart';

class EntityFactory {
  static CrossIdEntity makeAccount() =>
      CrossIdEntity(crossId: faker.guid.guid());

  static LoginDataEntity makeLoginData() => LoginDataEntity(
        url: faker.internet.httpUrl(),
        userName: faker.person.name(),
      );
}
