import 'package:clean_celta_mobile/data/usecases/enterprise/enterprise.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/infra/helpers/helperts.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalEnterpriseData sut;
  late HiveStorageSpy cacheStorage;
  late Map data;

  setUp(() {
    data = CacheFactory.makeEnterpriseData();
    cacheStorage = HiveStorageSpy();
    cacheStorage.mockGet(data);
    sut = LocalEnterpriseData(hiveStorage: cacheStorage);
  });

  group('load', () {
    test('Should call cacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.get(CacheKeys.enterprise.name)).called(1);
    });

    test('Should return a EnterpriseData on success', () async {
      final enterpriseDataEntity = await sut.load();

      expect(
        enterpriseDataEntity,
        EnterpriseEntity(
          url: data['url'].toString().toLowerCase().removeWhiteSpaces(),
          enterpriseName: data['enterpriseName']
              .toString()
              .toLowerCase()
              .removeWhiteSpaces(),
          enterpriseId: data["enterpriseId"],
          concentradorUrl: data["concentradorUrl"]
              .toString()
              .toLowerCase()
              .removeWhiteSpaces(),
        ),
      );
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockGet({});

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is isvalid', () async {
      cacheStorage.mockGet(CacheFactory.makeInvalidEnterpriseData());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockGet(CacheFactory.makeIncompleteEnterpriseData());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockGetError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
