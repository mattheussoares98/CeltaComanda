import 'package:clean_celta_mobile/domain/entities/entities.dart';

import 'package:faker/faker.dart';

class EntityFactory {
  static CrossIdEntity makeAccount() =>
      CrossIdEntity(crossId: faker.guid.guid());
  static final String url = faker.internet.httpUrl();

  static LoginDataEntity makeLoginData() => LoginDataEntity(
        url: url,
        userName: faker.person.name(),
        enterpriseName: !url.contains("http") ? url : "",
      );
}
