import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';

import '../../../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LoadCrossId sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late String crossId;

  setUp(() {
    crossId = faker.guid.guid();
    secureCacheStorage = SecureCacheStorageSpy();
    secureCacheStorage.mockFetch(crossId);
    sut = LocalLoadCrossId(fetchSecureCacheStorage: secureCacheStorage);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => secureCacheStorage.fetch(CacheKeys.crossId.name));
  });

  test('Should return an CrossIdEntity', () async {
    final account = await sut.load();

    expect(account, CrossIdEntity(crossId: crossId));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    secureCacheStorage.mockFetchError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if FetchSecureCacheStorage returns null',
      () async {
    secureCacheStorage.mockFetch(null);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
