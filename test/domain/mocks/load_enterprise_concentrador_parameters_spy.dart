// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoadEnterpriseConcentradorParametersSpy extends Mock
    implements LoadEnterpriseConcentradorParameters {
  LoadEnterpriseConcentradorParametersSpy() {
    when(() => this.load(any())).thenAnswer((any) async => any);
  }
}
