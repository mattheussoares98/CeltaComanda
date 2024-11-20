// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class LoginManagementSpy extends Mock implements LoginManagement {
  LoginManagementSpy() {
    this._mockLogout();
    this._mockLogin();
  }
  When _mockLogoutCall() => when(() => this.logout());

  void _mockLogout() {
    this._mockLogoutCall().thenAnswer((any) async => any);
  }

  void mockLogoutError() {
    this._mockLogoutCall().thenThrow(DomainError.unexpected);
  }

  When _mockLoginCall() => when(() => this.login(
        email: any(named: "email"),
        password: any(named: "password"),
      ));

  void _mockLogin() {
    this._mockLoginCall().thenAnswer((any) async => any);
  }

  void mockLoginError() {
    this._mockLoginCall().thenThrow(DomainError.unexpected);
  }
}
