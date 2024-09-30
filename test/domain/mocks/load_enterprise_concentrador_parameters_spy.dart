// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadEnterpriseConcentradorParametersSpy extends Mock
    implements LoadEnterpriseConcentradorParameters {
  mockLoadEnterprise(EnterpriseConcentradorParametersEntity entity) {
    when(() => this.load(any())).thenAnswer((any) async => entity);
  }
}
