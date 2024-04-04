import 'package:clean_celta_mobile/data/usecases/save_url/save_url.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';

import '../../mocks/cache_storage_spy.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalSaveUrl sut;
  late CacheStorageSpy cacheStorage;
  late String url;

  setUp(() {
    cacheStorage = CacheStorageSpy();
    url = faker.internet.httpUrl();
    sut = LocalSaveUrl(cacheStorage: cacheStorage);
  });

  test('Should call SaveCacheStorage with correct values', () async {
    await sut.save(url);

    verify(() => cacheStorage.save(key: 'url', value: url));
  });

  test('Should throw UnexpectedError if SaveCacheStorage throws', () async {
    cacheStorage.mockSaveError();

    final future = sut.save(url);

    expect(future, throwsA(DomainError.unexpected));
  });
}
