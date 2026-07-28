// ignore_for_file: unnecessary_this
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class CieloPaySpy extends Mock implements CieloPay {
  CieloPaySpy() {
    this.mockPay();
  }

  When mockPaytCall() => when(() => this.pay(any()));
  void mockPay() => this.mockPaytCall().thenAnswer((any) async => {'responsecode': 0, 'responseJson': '{}'});
  void mockPayError(DomainError error) => this.mockPaytCall().thenThrow(error);
}
