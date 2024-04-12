// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/usecases/login_data/login_data.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class LocalLoginDataSpy extends Mock implements LocalLoginData {
  When mockSaveCall() => when(() => this.add(any()));
  void mockSave(LoginDataEntity loginData) =>
      this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(DomainError.unexpected);

  When mockLoadCall() => when(() => load());
  void mockLoad(LoginDataEntity loginDataEntity) =>
      mockLoadCall().thenAnswer((_) async => loginDataEntity);
  void mockLoadError() => mockLoadCall().thenThrow(Exception());
}
