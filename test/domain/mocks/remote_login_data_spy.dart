// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/usecases/login_data/login_data.dart';
import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoginDataSpy extends Mock implements RemoteLoginData {
  When mockAddCall() => when(() => this.add(any()));
  void mockAdd(LoginDataEntity entity) =>
      this.mockAddCall().thenAnswer((_) async => entity);
  void mockSaveError() => this.mockAddCall().thenThrow(DomainError.unexpected);

  When mockRemoteLoadDataCall() =>
      when(() => this.load(loginEntity: any(named: "loginEntity")));
  void mockRemoteLoad(LoginDataEntity? entity) =>
      this.mockRemoteLoadDataCall().thenAnswer((_) async => entity);
  void mockRemoteLoadError() => this.mockRemoteLoadDataCall().thenThrow(Exception());
}
