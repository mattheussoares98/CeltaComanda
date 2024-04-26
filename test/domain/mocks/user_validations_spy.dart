// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class UserValidationsSpy extends Mock implements UserValidations {
  UserValidationsSpy() {
    this.mockCanCancel(true);
    this.mockIsValidPassword(true);
  }

  When mockCanCancelCall() => when(
        () => this.canCancel(
          personalizedCode: any(named: "personalizedCode"),
          url: any(named: "url"),
        ),
      );
  void mockCanCancel(bool canCancel) {
    this.mockCanCancelCall().thenAnswer((_) async => canCancel);
  }

  When mockIsValidPasswordCall() => when(
        () => this.isValidPassword(
          url: any(named: "url"),
          personalizedCode: any(named: "personalizedCode"),
          password: any(named: "password"),
        ),
      );
  void mockIsValidPassword(bool isValid) {
    this.mockIsValidPasswordCall().thenAnswer((_) async => isValid);
  }

  void mockIsValidPasswordError(DomainError error) {
    this.mockIsValidPasswordCall().thenThrow(error);
  }

  void mockCanCancelError(DomainError error){
    this.mockCanCancelCall().thenThrow(error);
  }
}
