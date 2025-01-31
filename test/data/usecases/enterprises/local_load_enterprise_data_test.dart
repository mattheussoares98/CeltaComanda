import 'package:clean_celta_mobile/data/usecases/enterprise/enterprise.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/infra/helpers/helpers.dart';
import 'package:clean_celta_mobile/ui/helpers/helpers.dart';

import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

import 'package:mocktail/mocktail.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalEnterpriseData sut;
  late HiveStorageSpy cacheStorage;
  late Map enterpriseJsonData;

  setUp(() {
    enterpriseJsonData = CacheFactory.makeEnterpriseData();
    cacheStorage = HiveStorageSpy();
    cacheStorage.mockGet(enterpriseJsonData);
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
          url: enterpriseJsonData['url']
              .toString()
              .toLowerCase()
              .removeWhiteSpaces(),
          enterpriseName: enterpriseJsonData['enterpriseName']
              .toString()
              .toLowerCase()
              .removeWhiteSpaces(),
          enterpriseId: enterpriseJsonData["enterpriseId"],
          concentradorUrl: enterpriseJsonData["concentradorUrl"]
              .toString()
              .toLowerCase()
              .removeWhiteSpaces(),
          urlCCS: enterpriseJsonData["urlCCS"]
              .toString()
              .toLowerCase()
              .removeWhiteSpaces(),
          persistApp: enterpriseJsonData["persistApp"],
          useCovenant: enterpriseJsonData["useCovenant"],
          enterpriseConcentradorParametersEntity:
              enterpriseJsonData["enterpriseConcentradorParametersEntity"],
          updateMenu: enterpriseJsonData["updateMenu"],
          serviceChargePercentageOrValue:
              enterpriseJsonData["serviceChargePercentageOrValue"],
          updateDevicesInformations:
              enterpriseJsonData["updateDevicesInformations"],
          serviceChargeType: enterpriseJsonData["serviceChargeType"],
          updateEnterprise: enterpriseJsonData["updateEnterprise"],
          zoomImage: enterpriseJsonData["zoomImage"],
          pendingDevicesToUpdate: enterpriseJsonData["pendingDevicesToUpdate"],
          updatePendingDevices: enterpriseJsonData["updatePendingDevices"],
          waitDaysToPreloadImages:
              enterpriseJsonData["waitDaysToPreloadImages"],
          latestCompatibleVersion:
              enterpriseJsonData["latestCompatibleVersion"],
          minutesVerifyUpdateMenu:
              enterpriseJsonData["minutesVerifyUpdateMenu"],
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
