import 'package:faker/faker.dart';

class CacheFactory {
  static Map makeEnterpriseData() => {
        'url': faker.internet.httpUrl(),
        'urlCCS': faker.internet.httpUrl(),
        'concentradorUrl': faker.internet.httpUrl(),
        'enterpriseName': faker.company.name(),
        'enterpriseId': faker.randomGenerator.integer(2),
        'persistApp': faker.randomGenerator.boolean(),
        'useCovenant': faker.randomGenerator.boolean(),
        'updateMenuCount': faker.randomGenerator.integer(100),
        'updateEnterpriseCount': faker.randomGenerator.integer(100),
        'serviceChargePercentageOrValue': faker.randomGenerator.decimal(),
      };

  static Map makeInvalidEnterpriseData() => {
        'url': false,
        'userName': {},
      };

  static Map makeIncompleteEnterpriseData() => {
        'url': 'http://localhost:9090',
      };
}
