import 'package:clean_celta_mobile/domain/entities/entities.dart';

import 'package:faker/faker.dart';

class EntityFactory {
  static CrossIdEntity makeAccount() =>
      CrossIdEntity(crossId: faker.guid.guid());

  static LoginDataEntity makeLoginData() {
    final String url = faker.internet.httpUrl();
    return LoginDataEntity(
      url: url,
      userName: faker.person.name(),
      enterpriseName: !url.contains("http") ? url : "",
    );
  }

  static List<ProductEntity> makeProducts() {
    return [
      ProductEntity(
        image: faker.internet.httpUrl(),
        price: faker.randomGenerator.decimal(),
        name: faker.food.random.string(10),
        plu: faker.randomGenerator.integer(5).toString(),
      ),
      ProductEntity(
        image: faker.internet.httpUrl(),
        price: faker.randomGenerator.decimal(),
        name: faker.food.random.string(10),
        plu: faker.randomGenerator.integer(5).toString(),
      ),
    ];
  }

  static List<ExpansibleGroupEntity> makeExpansibleGroups() {
    return [
      ExpansibleGroupEntity(name: faker.randomGenerator.string(30)),
      ExpansibleGroupEntity(name: faker.randomGenerator.string(30)),
    ];
  }
}
