// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class ClearPrintedProductsSpy extends Mock implements ClearPrintedProducts {
  ClearPrintedProductsSpy() {
    this.mockLoadPrintedProducts(null);
  }

  When mockLoadPrintedProductsCall() => when(() => this.clear());

  void mockLoadPrintedProducts(PrintedViewModel? value) {
    this.mockLoadPrintedProductsCall().thenAnswer((_) => value);
  }
}
