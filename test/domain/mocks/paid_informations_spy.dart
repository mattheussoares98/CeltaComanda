// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class PaidInformationsSpy extends Mock implements PaidInformations {
  PaidInformationsSpy() {
    this.mockGetAlreadyPaid(true);
  }

  When mockGetPaidInformationsCall() => when(() => this.getAlreadyPaid());

  void mockGetAlreadyPaid(bool paid) {
    this.mockGetPaidInformationsCall().thenAnswer((_) async => paid);
  }

  void mockGetAlreadyPaidError(DomainError error) {
    this.mockGetPaidInformationsCall().thenThrow(error);
  }

  When mockUpdateAlreadyPaidCall(bool newValue) =>
      when(() => this.updateAlreadyPaid(newValue));

  void mockUpdateAlreadyPaid(bool newValue) {
    this.mockUpdateAlreadyPaidCall(newValue).thenAnswer((_) async => _);
  }

  void mockUpdateAlreadyPaidError(DomainError error) {
    this.mockUpdateAlreadyPaidCall(false).thenThrow(error);
  }
}
