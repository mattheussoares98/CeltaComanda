// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CovenantLimitSpy extends Mock implements CovenantLimit {
  When _mockAuthorizeCall() =>
      when(() => this.authorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
            crossIdentity: any(named: "crossIdentity"),
            covenantCode: any(named: "covenantCode"),
            customerCode: any(named: "customerCode"),
            value: any(named: "value"),
          ));

  void mockAuthorizeCovenantLimitUseByCodeAndGetAuthorizeCode(
    dynamic soapResponse,
  ) {
    _mockAuthorizeCall().thenAnswer((any) async => soapResponse);
  }

  void mockError() {
    _mockAuthorizeCall().thenThrow(DomainError.unexpected);
  }
}
