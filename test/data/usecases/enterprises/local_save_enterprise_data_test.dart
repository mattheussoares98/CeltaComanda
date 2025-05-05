import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/data/usecases/enterprise/enterprise.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/infra/helpers/helpers.dart';

import '../../../domain/mocks/mocks.dart';
import '../../mocks/mocks.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalEnterpriseData sut;
  late HiveStorageSpy cacheStorage;
  late EnterpriseEntity enterpriseData;

  setUp(() {
    cacheStorage = HiveStorageSpy();
    enterpriseData = EnterpriseEntity(
      url: faker.internet.httpUrl(),
      urlCCS: faker.internet.httpUrl(),
      enterpriseName: faker.company.name(),
      enterpriseId: faker.randomGenerator.integer(3),
      concentradorUrl: faker.internet.httpUrl(),
      persistApp: faker.randomGenerator.boolean(),
      useCovenant: faker.randomGenerator.boolean(),
      enterpriseConcentradorParametersEntity:
          EntityFactory.makeEnterpriseConcentradorParametersEntity(),
      updateDevicesInformations: faker.randomGenerator.integer(100),
      updateEnterprise: faker.randomGenerator.integer(100),
      serviceChargePercentageOrValue: faker.randomGenerator.decimal(),
      zoomImage: faker.randomGenerator.boolean(),
      latestCompatibleVersion: faker.randomGenerator.decimal().toString(),
      minutesVerifyUpdateMenu: faker.randomGenerator.integer(100),
      useReducedNameOnProduct: faker.randomGenerator.boolean(),
      verifyCommandBlocked: faker.randomGenerator.boolean(),
      canInsertCommentManually: faker.randomGenerator.boolean(),
      blockUseAppIfIsOutdated: faker.randomGenerator.boolean(),
      canInsertQuantityManually: faker.randomGenerator.boolean(),
      canInsertCustomer: faker.randomGenerator.boolean(),
      requestTableNumber: faker.randomGenerator.boolean(),
      firebaseEnterpriseId: faker.guid.guid(),
    );
    sut = LocalEnterpriseData(hiveStorage: cacheStorage);
  });

  test('Should call LocalSaveEnterpriseData with correct values', () async {
    await sut.add(enterpriseData);

    verify(() => cacheStorage.put(
          CacheKeys.enterprise.name,
          EnterpriseModel.fromEntity(enterpriseData).toJson(),
        ));
  });

  test('Should throw UnexpectedError if LocalSaveEnterpriseData throws',
      () async {
    cacheStorage.mockSaveError();

    final future = sut.add(enterpriseData);

    expect(future, throwsA(DomainError.unexpected));
  });
}
