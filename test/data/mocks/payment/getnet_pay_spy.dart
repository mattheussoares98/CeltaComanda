// ignore_for_file: unnecessary_this
import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

class GetnetPaySpy extends Mock implements GetnetPay {
  GetnetPaySpy() {
    this.mockPay(null);
  }

  When mockPaytCall() => when(() => this.pay(any()));
  void mockPay(Map<String, dynamic>? result) => this.mockPaytCall().thenAnswer(
        (any) async => result,
      );
  void mockPayError(DomainError error) => this.mockPaytCall().thenThrow(error);
}
