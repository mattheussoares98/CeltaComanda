import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';

import 'package:faker/faker.dart';

class EntityFactory {
  static EnterpriseEntity makeEnterpriseData() {
    final String url = faker.internet.httpUrl();
    return EnterpriseEntity(
      url: url,
      enterpriseId: faker.randomGenerator.integer(3),
      enterpriseName: faker.company.name(),
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

  static ProductsViewModel makeProductViewModel() {
    return ProductsViewModel(
      image: faker.internet.httpUrl(),
      price: faker.randomGenerator.decimal().toString(),
      name: faker.food.random.string(10),
      plu: faker.randomGenerator.integer(5).toString(),
    );
  }

  static ApiSaleRequestEntity makeApiSaleRequestEntity() {
    return ApiSaleRequestEntity(
      Products: [],
      SaleRequestTempId: faker.randomGenerator.integer(10),
      PersonalizedCode: faker.randomGenerator.string(10),
      EnterpriseId: faker.randomGenerator.integer(3),
      TotalLiquid: faker.randomGenerator.decimal(),
      DeliveryControl: faker.randomGenerator.integer(5),
      Comments: faker.randomGenerator.string(50),
    );
  }
}
