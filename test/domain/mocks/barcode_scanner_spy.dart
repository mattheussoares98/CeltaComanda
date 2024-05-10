// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class BarcodeScannerSpy extends Mock implements BarcodeScanner {
  BarcodeScannerSpy() {
    this.mockBarcodeScanner("");
  }

  When mockBarcodeScannerCall() => when(() => this.read());

  void mockBarcodeScanner(String barcode) {
    this.mockBarcodeScannerCall().thenAnswer((_) async => barcode);
  }

  void mockBarcodeScannerError() {
    this.mockBarcodeScannerCall().thenThrow(DomainError.unexpected);
  }
}
