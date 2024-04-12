// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/usecases/login_data/login_data.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoginDataSpy extends Mock implements RemoteLoginData {
  When mockAddCall() => when(() => this.add(any()));
  void mockAdd(LoginDataEntity loginData) =>
      this.mockAddCall().thenAnswer((_) async => loginData);
  void mockSaveError() => this.mockAddCall().thenThrow(DomainError.unexpected);

  When mockRemoteLoadDataCall() =>
      when(() => load(loginEntity: any(named: "loginEntity")));
  void mockRemoteLoad(LoginDataEntity? loginDataEntity) =>
      mockRemoteLoadDataCall().thenAnswer((_) async => loginDataEntity);
  void mockRemoteLoadError() => mockRemoteLoadDataCall().thenThrow(Exception());
}
