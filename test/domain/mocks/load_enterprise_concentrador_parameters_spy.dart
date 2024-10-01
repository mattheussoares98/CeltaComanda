// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadEnterpriseConcentradorParametersSpy extends Mock
    implements LoadEnterpriseConcentradorParameters {
  When _mockLoadEnterpriseCall() => when(() => this.load(
        enterpriseId: any(named: "enterpriseId"),
        concentradorUrl: any(named: "concentradorUrl"),
      ));

  mockLoadEnterprise(EnterpriseConcentradorParametersEntity entity) {
    _mockLoadEnterpriseCall().thenAnswer((any) async => entity);
  }

  mockLoadEnterpriseError() {
    _mockLoadEnterpriseCall().thenThrow(DomainError.unexpected);
  }
}
