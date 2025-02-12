// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class ConcentratorLoginSpy extends Mock implements ConcentratorLogin {
  When _mockLoginCall() => when(() => this.login(
        username: any(named: "username"),
        password: any(named: "password"),
      ));

  void mockLogin(UserConcentratorEntity? entity) {
    this._mockLoginCall().thenAnswer((any) async => entity);
  }

  void mockLoginError() {
    this._mockLoginCall().thenThrow(DomainError.unexpected);
  }
}
