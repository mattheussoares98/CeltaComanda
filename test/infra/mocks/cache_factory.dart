import 'package:faker/faker.dart';

class CacheFactory {
  static Map makeEnterpriseData() => {
        'url': faker.internet.httpUrl(),
        'enterpriseName': faker.company.name(),
        'enterpriseId': faker.randomGenerator.integer(2),
      };

  static Map makeInvalidEnterpriseData() => {
        'url': false,
        'userName': {},
      };

  static Map makeIncompleteEnterpriseData() => {
        'url': 'http://localhost:9090',
      };
}
