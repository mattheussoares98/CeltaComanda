import 'package:faker/faker.dart';

class CacheFactory {
  static Map makeLoginData() => {
        'url': faker.internet.httpUrl(),
        'userName': faker.person.name(),
      };

  static Map makeInvalidLoginData() => {
        'url': false,
          'userName': {},
      };

  static Map makeIncompleteLoginData() => {
        'url': 'http://localhost:9090',
      };
}
