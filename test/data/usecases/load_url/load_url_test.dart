import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import '../../mocks/cache_storage_spy.dart';
import '../../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LoadUrl sut;
  late CacheStorageSpy cacheStorage;
  late String fakeUrl;

  setUp(() {
    fakeUrl = faker.internet.httpUrl();
    cacheStorage = CacheStorageSpy();
    cacheStorage.mockGet(fakeUrl);
    sut = LocalLoadUrl(cacheStorage: cacheStorage);
  });

  test('Should call CacheStorage with correct value', () async {
    await sut.load();

    verify(() => cacheStorage.get('url'));
  });

  test('Should return an Url', () async {
    final url = await sut.load();

    expect(url, fakeUrl);
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
