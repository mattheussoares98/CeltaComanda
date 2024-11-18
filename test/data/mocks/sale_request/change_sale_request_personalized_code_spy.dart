// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class ChangeSaleRequestPersonalizedCodeSpy extends Mock
    implements ChangeSaleRequestPersonalizedCode {
  ChangeSaleRequestPersonalizedCodeSpy() {
    this.mockChange();
  }

  When _mockChangeCall() => when(() => this.change(
        oldPersonalizedCode: any(named: "oldPersonalizedCode"),
        newPersonalizedCode: any(named: "newPersonalizedCode"),
      ));

  void mockChange() {
    this._mockChangeCall().thenAnswer((any) async => any);
  }

  void mockError(DomainError error) {
    this._mockChangeCall().thenThrow(error);
  }
}
