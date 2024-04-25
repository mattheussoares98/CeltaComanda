// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class ClearSaleRequestTempSpy extends Mock implements ClearSaleRequestTemp {
  ClearSaleRequestTempSpy() {
    this.mockLoadPrintedProducts(null);
  }

  When mockLoadPrintedProductsCall() => when(() => this.clear());

  void mockLoadPrintedProducts(SaleRequestTempViewModel? value) {
    this.mockLoadPrintedProductsCall().thenAnswer((_) => value);
  }
}
