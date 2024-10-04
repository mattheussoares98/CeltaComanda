// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CovenantAuthorizationIsPendantSpy extends Mock
    implements CovenantAuthorizationIsPendant {
  CovenantAuthorizationIsPendantSpy() {
    mockGet(true);
    mockUpdate(true);
  }

  When _mockGetCall() => when(() => this.get());
  void mockGetError() {
    _mockGetCall().thenThrow(Exception());
  }

  void mockGet(bool value) {
    _mockGetCall().thenAnswer((any) async => value);
  }

  When _mockUpdateCall(bool value) => when(() => this.update(value));
  void mockUpdateError() {
    _mockUpdateCall(false).thenThrow(Exception());
  }

  void mockUpdate(bool value) {
    _mockUpdateCall(value).thenAnswer((any) async => any);
  }
}
