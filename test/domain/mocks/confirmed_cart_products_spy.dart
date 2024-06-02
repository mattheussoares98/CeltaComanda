// ignore_for_file: unnecessary_this
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class ConfirmedCartProductsSpy extends Mock implements ConfirmedCartProducts {
  ConfirmedCartProductsSpy() {
    this.mockIsConfirmed();
    mockUpdateValue();
  }

  When mockIsConfirmedCall() => when(() => this.isConfirmed());
  void mockIsConfirmed([bool isConfirmed = true]) =>
      this.mockIsConfirmedCall().thenAnswer((_) async => isConfirmed);
  void mockRemoteAddError() =>
      this.mockIsConfirmedCall().thenThrow(DomainError.unexpected);

  When mockUpdateValueCall() => when(() => this.updateValue(any()));
  void mockUpdateValue() =>
      this.mockUpdateValueCall().thenAnswer((_) async => _);
  void mockUpdateValueError() =>
      this.mockUpdateValueCall().thenThrow(DomainError.unexpected);
}
