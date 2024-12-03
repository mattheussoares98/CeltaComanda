// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class LoadEnterpriseDataSpy extends Mock implements LoadEnterpriseData {
  // When mockAddCall() => when(() => this.add(any()));
  // void mockAdd(EnterpriseDataEntity entity) =>
  //     this.mockAddCall().thenAnswer((_) async => entity);
  // void mockSaveError() => this.mockAddCall().thenThrow(DomainError.unexpected);

  When _mockLoadCall() => when(() => this.load());
  void mockLoad(EnterpriseEntity? entity) =>
      this._mockLoadCall().thenAnswer((_) async => entity);
  void mockLoadError(DomainError error) =>
      this._mockLoadCall().thenThrow(error);
}
