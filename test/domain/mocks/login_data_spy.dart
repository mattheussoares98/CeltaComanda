// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoginDataSpy extends Mock implements SaveLoginData, LoadLoginData {
  When mockSaveCall() => when(() => this.save(any()));
  void mockSave(LoginDataEntity loginData) =>
      this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(DomainError.unexpected);

  When mockLoadCall() => when(() => load());
  void mockLoad({required LoginDataEntity loginDataEntity}) =>
      mockLoadCall().thenAnswer((_) async => loginDataEntity);
  void mockLoadError() => mockLoadCall().thenThrow(Exception());
}
