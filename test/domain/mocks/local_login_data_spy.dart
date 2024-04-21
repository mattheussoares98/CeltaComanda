// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/usecases/usecases.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';

import 'package:mocktail/mocktail.dart';

class LocalLoginDataSpy extends Mock implements LocalLoginData {
  When mockSaveCall() => when(() => this.add(any()));
  void mockSave(LoginDataEntity entity) =>
      this.mockSaveCall().thenAnswer((_) async => entity);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());

  When mockLoadCall() => when(() => this.load());
  void mockLoad(LoginDataEntity entity) =>
      this.mockLoadCall().thenAnswer((_) async => entity);
  void mockLoadError() => this.mockLoadCall().thenThrow(Exception());
}
