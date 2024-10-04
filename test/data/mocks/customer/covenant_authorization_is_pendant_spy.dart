// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CovenantAuthorizationIsPendantSpy extends Mock
    implements CovenantAuthorizationIsPendant {
  CovenantAuthorizationIsPendantSpy() {
    this.mockGet(true);
    this.mockUpdate(true);
  }

  When _mockGetCall() => when(() => this.get());
  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }

  void mockGet(bool value) {
    this._mockGetCall().thenAnswer((any) async => value);
  }

  When _mockUpdateCall() => when(() => this.update(any()));
  void mockUpdateError() {
    this._mockUpdateCall().thenThrow(Exception());
  }

  void mockUpdate(bool value) {
    this._mockUpdateCall().thenAnswer((any) async => any);
  }
}
