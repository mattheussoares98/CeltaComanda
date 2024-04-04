import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import '../../mocks/cache_storage_spy.dart';
import '../../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LoadUser sut;
  late CacheStorageSpy cacheStorage;
  late String userName;

  setUp(() {
    userName = faker.person.name();
    cacheStorage = CacheStorageSpy();
    cacheStorage.mockGet(userName);
    sut = LocalLoadUser(cacheStorage: cacheStorage);
  });

  test('Should call CacheStorage with correct value', () async {
    await sut.load();

    verify(() => cacheStorage.get('userName'));
  });

  test('Should return an UserName', () async {
    final user = await sut.load();

    expect(user, userName);
  });

  test('Should throw UnexpectedError if FetchcacheStorage throws', () async {
    cacheStorage.mockGetError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if FetchcacheStorage returns null',
      () async {
    cacheStorage.mockGet(null);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
