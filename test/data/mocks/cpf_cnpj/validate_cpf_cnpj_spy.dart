import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class ValidateCpfCnpjSpy extends Mock implements ValidateCpfCnpj {
  ValidateCpfCnpjSpy() {
    this.mockIsValid(true);
  }
  When _mockCall() => when(() => this.isValid(any()));

  void mockIsValid(bool value) {
    this._mockCall().thenAnswer((any) => value);
  }

  void mockIsValidError() {
    this._mockCall().thenThrow(Exception());
  }
}
