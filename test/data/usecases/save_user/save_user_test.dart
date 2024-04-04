import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';

import '../../mocks/cache_storage_spy.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalSaveUser sut;
  late CacheStorageSpy cacheStorage;
  late String userName;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    userName = faker.person.name();
    sut = LocalSaveUser(cacheStorage: cacheStorage);
  });

  test('Should call SaveCacheStorage with correct values', () async {
    await sut.save(userName);

    verify(() => cacheStorage.save(key: 'userName', value: userName));
  });

  test('Should throw UnexpectedError if SaveCacheStorage throws', () async {
    cacheStorage.mockSaveError();

    final future = sut.save(userName);

    expect(future, throwsA(DomainError.unexpected));
  });
}
