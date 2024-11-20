// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';

import 'package:mocktail/mocktail.dart';

class LocalEnterpriseDataSpy extends Mock implements LocalEnterpriseData {
  When mockAddCall() => when(() => this.add(any()));
  void mockAdd(EnterpriseEntity entity) =>
      this.mockAddCall().thenAnswer((_) async => entity);
  void mockAddError() => this.mockAddCall().thenThrow(DomainError.unexpected);

  When mockLoadCall() => when(() => this.load());
  void mockLoad(EnterpriseEntity? entity) =>
      this.mockLoadCall().thenAnswer((_) async => entity);
  void mockLoadError() => this.mockLoadCall().thenThrow(Exception());
}
