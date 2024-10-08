// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CheckPasswordByCustomerCodeSpy extends Mock
    implements CheckPasswordByCustomerCode {
  When _mockCheckCall() => when(() => this.validate(
        customerCode: any(named: "customerCode"),
        password: any(named: "password"),
      ));

  void mockCheck(bool isValid) {
    _mockCheckCall().thenAnswer((any) async => isValid);
  }

  void mockError() {
    _mockCheckCall().thenThrow(DomainError.unexpected);
  }
}
