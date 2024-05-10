// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class BarcodeScannerSpy extends Mock implements BarcodeScanner {
  BarcodeScannerSpy() {
    this.mockLoadPrintedProducts("");
  }

  When mockLoadPrintedProductsCall() => when(() => this.read());

  void mockLoadPrintedProducts(String barcode) {
    this.mockLoadPrintedProductsCall().thenAnswer((_) => barcode);
  }
}
