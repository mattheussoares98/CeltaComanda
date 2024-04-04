import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';

import '../../../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalSaveCrossId sut;
  late SecureCacheStorageSpy secureCacheStorage;
  late CrossIdEntity account;

  setUp(() {
    secureCacheStorage = SecureCacheStorageSpy();
    account = CrossIdEntity(crossId: faker.guid.guid());
    sut = LocalSaveCrossId(saveSecureCacheStorage: secureCacheStorage);
  });

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(
        () => secureCacheStorage.save(key: CacheKeys.crossId.name, value: account.crossId));
  });

  test('Should throw UnexpectedError if SaveSecureCacheStorage throws',
      () async {
    secureCacheStorage.mockSaveError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
