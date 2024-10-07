// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/data/models/models.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class CovenantAuthorizationIsPendantSpy extends Mock
    implements CovenantAuthorizationIsPendant {
  When _mockGetCall() => when(() => this.get());
  void mockGetError() {
    this._mockGetCall().thenThrow(Exception());
  }

  void mockGet(AuthorizationPendingModel? model) {
    this._mockGetCall().thenAnswer((any) async => model);
  }

  When _mockUpdateCall() => when(() => this.update(any()));
  void mockUpdateError() {
    this._mockUpdateCall().thenThrow(Exception());
  }

  Future<void> mockUpdate() async {
    this._mockUpdateCall().thenAnswer((any) async => any);
  }
}
