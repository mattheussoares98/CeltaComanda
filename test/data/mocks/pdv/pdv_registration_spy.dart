// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/entities/entities.dart';
import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class PdvRegistrationSpy extends Mock implements PdvRegistration {
  PdvRegistrationSpy() {
    this._mockSetPdvRegister();
    this._mockUpdatePdvRegister();
  }
  When _mockGetPdvNotUsingCall() => when(() => this.getPdvNotUsing());
  void mockGetPdvNotUsing(List<PdvEntity> value) =>
      this._mockGetPdvNotUsingCall().thenAnswer((any) async => value);
  void mockGetPdvNotUsingError(DomainError error) =>
      this._mockGetPdvNotUsingCall().thenThrow(error);

  When _mockSetPdvRegisterCall() => when(() => this.setPdvRegister(
        pdvId: any(named: "pdvId"),
        imeiOrWindowsId: any(named: "imeiOrWindowsId"),
        versionNumber: any(named: "versionNumber"),
        ip: any(named: "ip"),
        isUsing: any(named: "isUsing"),
      ));
  void _mockSetPdvRegister() =>
      this._mockSetPdvRegisterCall().thenAnswer((any) async => any);
  void mockSetPdvRegisterError() =>
      this._mockSetPdvRegisterCall().thenThrow(Exception());

  When _mockGetByIdCall() => when(() => this.getById(any()));
  void mockGetById(PdvEntity? entity) =>
      this._mockGetByIdCall().thenAnswer((any) async => entity);
  void mockGetByIdError() =>
      this._mockGetByIdCall().thenAnswer((any) async => null);

  When _mockUpdatePdvRegisterCall() => when(() => this.updatePdvRegister(
        entity: any(named: "entity"),
        versionNumber: any(named: "versionNumber"),
      ));
  void _mockUpdatePdvRegister() =>
      this._mockUpdatePdvRegisterCall().thenAnswer((any) async => any);
  void mockUpdatePdvRegisterError() =>
      this._mockUpdatePdvRegisterCall().thenAnswer((any) async => null);
}
