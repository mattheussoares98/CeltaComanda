// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class PaidInformationsSpy extends Mock implements PaidInformations {
  PaidInformationsSpy() {
    this.mockGetAlreadyPaid(true);
    this.mockUpdateAlreadyPaid(true);
  }

  When mockGetAlreadyPaidCall() => when(() => this.getAlreadyPaid());

  void mockGetAlreadyPaid(bool paid) {
    this.mockGetAlreadyPaidCall().thenAnswer((_) async => paid);
  }

  void mockGetAlreadyPaidError(DomainError error) {
    this.mockGetAlreadyPaidCall().thenThrow(error);
  }

  When mockUpdateAlreadyPaidCall() => when(() => this.updateAlreadyPaid(any()));

  void mockUpdateAlreadyPaid(bool newValue) {
    this.mockUpdateAlreadyPaidCall().thenAnswer((_) async => newValue);
  }

  void mockUpdateAlreadyPaidError(DomainError error) {
    this.mockUpdateAlreadyPaidCall().thenThrow(error);
  }
}
