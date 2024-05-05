// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';

import 'package:mocktail/mocktail.dart';

class FinishSaleRequestTempSpy extends Mock implements FinishSaleRequestTemp {
  FinishSaleRequestTempSpy() {
    this.mockFinishSaleRequestTemp();
  }
  When mockFinishSaleRequestTempCall() => when(() => this.finish(
        saleRequestTempEntity: any(named: "saleRequestTempEntity"),
        url: any(named: "url"),
      ));

  void mockFinishSaleRequestTemp() =>
      this.mockFinishSaleRequestTempCall().thenAnswer((_) async => _);

  void mockFinishSaleRequestTempError() =>
      this.mockFinishSaleRequestTempCall().thenThrow(Exception());
}
