import 'package:clean_celta_mobile/data/usecases/login_data/login_data.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';

void main() {
  late LocalLoginData sut;
  late HiveStorageSpy cacheStorage;
  late Map data;
  late LoginDataEntity loginData;

  setUp(() {
    loginData = EntityFactory.makeLoginData();
    data = CacheFactory.makeLoginData();
    cacheStorage = HiveStorageSpy();
    cacheStorage.mockGet(data);
    sut = LocalLoginData(hiveStorage: cacheStorage);
  });

  group('load', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.get(CacheKeys.loginData.name)).called(1);
    });

    test('Should return a LoginData on success', () async {
      final surveys = await sut.load();

      expect(
        surveys,
        LoginDataEntity(url: data['url'], userName: data['userName']),
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockGet({});

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is isvalid', () async {
      cacheStorage.mockGet(CacheFactory.makeInvalidLoginData());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockGet(CacheFactory.makeIncompleteLoginData());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockGetError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  // group('validate', () {
  //   test('Should call cacheStorage with correct key', () async {
  //     await sut.validate();

  //     verify(() => cacheStorage.get(CacheKeys.loginData.name)).called(1);
  //   });

  //   test('Should delete cache if it is invalid', () async {
  //     cacheStorage.mockGet(CacheFactory.makeInvalidLoginData());

  //     await sut.validate();

  //     verify(() => cacheStorage.delete(CacheKeys.loginData.name)).called(1);
  //   });

  //   test('Should delete cache if it is incomplete', () async {
  //     cacheStorage.mockGet(CacheFactory.makeIncompleteLoginData());

  //     await sut.validate();

  //     verify(() => cacheStorage.delete(CacheKeys.loginData.name)).called(1);
  //   });

  //   test('Should delete cache if get fails', () async {
  //     cacheStorage.mockGetError();

  //     await sut.validate();

  //     verify(() => cacheStorage.delete(CacheKeys.loginData.name)).called(1);
  //   });
  // });

  group('save', () {
    test('Should call cacheStorage with correct values', () async {
      final map = {
        'url': loginData.url,
        'userName': loginData.userName,
      };

      await sut.save(loginData);

      verify(() => cacheStorage.put(CacheKeys.loginData.name, map)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      cacheStorage.mockSaveError();

      final future = sut.save(loginData);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
