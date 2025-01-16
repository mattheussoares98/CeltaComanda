// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class UpdateDeviceInformationsSpy extends Mock
    implements UpdateDeviceInformations {
  UpdateDeviceInformationsSpy() {
    this.mockUpdate();
  }
  When _mockUpdateCall() => when(() => this.update(any()));

  void mockUpdate() {
    this._mockUpdateCall().thenAnswer((any) async => any);
  }

  void mockError() {
    this._mockUpdateCall().thenThrow(DomainError.unexpected);
  }
}
