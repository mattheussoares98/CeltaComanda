// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class BarcodeScannerSpy extends Mock implements BarcodeScanner {
  BarcodeScannerSpy() {
    this.mockRead("");
  }

  When _mockRead() => when(() => this.read());

  void mockRead(String barcode) {
    this._mockRead().thenAnswer((_) async => barcode);
  }

  void mockError(DomainError error) {
    this._mockRead().thenThrow(error);
  }
}
