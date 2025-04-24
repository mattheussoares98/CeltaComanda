// ignore_for_file: unnecessary_this
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class PaySpy extends Mock implements RedePay {
  PaySpy() {
    this.mockPay();
  }

  When mockPaytCall() => when(() => this.pay(any()));
  void mockPay() => this.mockPaytCall().thenAnswer((any) async => any);
  void mockPayError(DomainError error) => this.mockPaytCall().thenThrow(error);
}
