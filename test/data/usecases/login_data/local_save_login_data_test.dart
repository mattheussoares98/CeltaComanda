import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/data/usecases/login_data/login_data.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';

import '../../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalLoginData sut;
  late HiveStorageSpy cacheStorage;
  late LoginDataEntity loginData;

  setUp(() {
    cacheStorage = HiveStorageSpy();
    loginData = LoginDataEntity(
      url: faker.internet.httpUrl(),
      userName: faker.person.name(),
    );
    sut = LocalLoginData(hiveStorage: cacheStorage);
  });

  test('Should call LocalSaveLoginData with correct values', () async {
    await sut.save(loginData);

    verify(() => cacheStorage.put(
          CacheKeys.loginData.name,
          LoginDataModel.fromEntity(loginData).toJson(),
        ));
  });

  test('Should throw UnexpectedError if LocalSaveLoginData throws', () async {
    cacheStorage.mockSaveError();

    final future = sut.save(loginData);

    expect(future, throwsA(DomainError.unexpected));
  });
}
