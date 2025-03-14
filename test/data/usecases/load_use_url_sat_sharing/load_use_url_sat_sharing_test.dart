import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/main/builders/builders.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../domain/mocks/mocks.dart';

void main() {
  late LocalLoadUseUrlSatSharing sut;

  setUp(() {
    sut = LocalLoadUseUrlSatSharing();
  });

  group("Load", () {
    test("Should return false if cpfCnpj is not null", () {
      final useSatSharing = sut.getUse(faker.randomGenerator.integer(11));

      expect(useSatSharing, false);
    });

    test("Should return false if urlSATSharingTotalCouponGroup is null", () {
      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseWithNullValue(
        atualEntity: EntityFactory.makeEnterpriseData(),
        enterpriseConcentradorParametersEntity: true,
      );

      final useSatSharing = sut.getUse(null);

      expect(useSatSharing, false);
    });
    test("Should return false if urlSATSharingTotalCouponGroup is 100", () {
      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData(
        enterpriseConcentradorParametersEntity:
            EntityFactory.makeEnterpriseConcentradorParametersEntity(
          urlSATSharingTotalCouponGroup: 100,
        ),
      );

      final useSatSharing = sut.getUse(null);

      expect(useSatSharing, false);
    });
    test("Should return true if urlSATSharingTotalCouponGroup is 99", () {
      EnterpriseBuilder.entity = EntityFactory.makeEnterpriseData(
        enterpriseConcentradorParametersEntity:
            EntityFactory.makeEnterpriseConcentradorParametersEntity(
          urlSATSharingTotalCouponGroup: 99,
        ),
      );

      final useSatSharing = sut.getUse(null);

      expect(useSatSharing, true);
    });
  });
}
