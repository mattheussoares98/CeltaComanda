// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class ValidateComboxSpy extends Mock implements ValidateCombox {
  ValidateComboxSpy() {
    this.mockValidateCombox();
  }
  When mockValidateComboxCall() => when(
        () => this.comboxIsValid(any()),
      );

  void mockValidateCombox([bool isValid = true]) {
    this.mockValidateComboxCall().thenAnswer((_) => isValid);
  }
}
