// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CovenantAuthorizationIsPendantSpy extends Mock
    implements CovenantAuthorizationIsPendant {
  CovenantAuthorizationIsPendantSpy() {
    mockGet(true);
    mockUpdate(true);
  }

  void mockGet(bool value) {
    when(() => this.get()).thenAnswer((any) async => value);
  }

  void mockUpdate(bool value) {
    when(() => this.update(value)).thenAnswer((any) async => any);
  }
}
