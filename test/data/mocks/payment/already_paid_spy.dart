// ignore_for_file: unnecessary_this
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class AlreadyPaidSpy extends Mock implements AlreadyPaid {
  AlreadyPaidSpy() {
    this.mockUpdate();
    this.mockVerify(true);
  }

  When _mockUpdateCall() => when(() => this.update(any()));
  void mockUpdate() => this._mockUpdateCall().thenAnswer((any) async => any);
  void mockUpdateError() =>
      this._mockUpdateCall().thenThrow(DomainError.unexpected);

  When _mockVerifyCall() => when(() => this.verify());
  void mockVerify(bool value) =>
      this._mockVerifyCall().thenAnswer((_) async => value);
  void mockVerifyError() =>
      this._mockVerifyCall().thenThrow(DomainError.unexpected);
}
