// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class AuthorizeCovenantLimitUseByCodeSpy extends Mock
    implements AuthorizeCovenantLimitUseByCode {
  AuthorizeCovenantLimitUseByCodeSpy() {
    mockAuthorize();
  }
  When _mockAuthorizeCall() => when(() => this.authorize(
        crossIdentity: any(named: "crossIdentity"),
        covenantCode: any(named: "covenantCode"),
        customerCode: any(named: "customerCode"),
        value: any(named: "value"),
      ));

  void mockAuthorize() {
    _mockAuthorizeCall().thenAnswer((any) async => any);
  }

  void mockError() {
    _mockAuthorizeCall().thenThrow(DomainError.unexpected);
  }
}
