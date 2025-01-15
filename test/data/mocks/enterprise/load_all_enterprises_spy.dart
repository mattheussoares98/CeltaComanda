// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadAllEnterprisesSpy extends Mock implements LoadAllEnterprises {
  When _mockLoadAllCall() => when(() => this.load());
  void mockLoadAll(List<EnterpriseEntity> entitys) =>
      this._mockLoadAllCall().thenAnswer((_) async => entitys);
  void mockLoadAllError() => this._mockLoadAllCall().thenThrow(Exception());
}
