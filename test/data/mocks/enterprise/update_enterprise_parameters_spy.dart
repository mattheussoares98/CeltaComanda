// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class UpdateEnterpriseParametersSpy extends Mock
    implements UpdateEnterpriseParameters {
  UpdateEnterpriseParametersSpy() {
    this.mockUpdate();
  }
  When _mockUpdateCall() => when(() => this.update(any()));
  void mockUpdate() => this._mockUpdateCall().thenAnswer((any) async => any);
  void mockUpdateError() => this._mockUpdateCall().thenThrow(Exception());
}
