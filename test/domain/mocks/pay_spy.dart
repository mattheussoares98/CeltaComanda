// ignore_for_file: unnecessary_this
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class PaySpy extends Mock implements Pay {
  PaySpy() {
    this.mockPay();
  }

  When mockPaytCall() => when(() => this.pay(
        paymentMode: any(named: "paymentMode"),
        params: any(named: "params"),
      ));
  void mockPay() => this.mockPaytCall().thenAnswer((_) async => _);
  void mockPayError(DomainError error) => this.mockPaytCall().thenThrow(error);
}
