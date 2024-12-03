// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class PdvRegistrationSpy extends Mock implements PdvRegistration {
  PdvRegistrationSpy() {
    this._mockGetPdvNotUsing();
  }
  When _mockGetPdvNotUsingCall() => when(() => this.getPdvNotUsing());
  void _mockGetPdvNotUsing() =>
      this._mockGetPdvNotUsingCall().thenAnswer((any) async => any);
  void mockGetPdvNotUsingError() =>
      this._mockGetPdvNotUsingCall().thenThrow(DomainError.unexpected);

  When _mockSetPdvRegisterCall() => when(() => this.setPdvRegister(
        pdvId: any(named: "pdvId"),
        uniqueIdentifier: any(named: "uniqueIdentifier"),
        versionNumber: any(named: "versionNumber"),
      ));
  void mockSetPdvRegister() =>
      this._mockSetPdvRegisterCall().thenAnswer((any) async => any);
  void mockSetPdvRegisterError() =>
      this._mockSetPdvRegisterCall().thenThrow(Exception());
}
