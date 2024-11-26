// ignore_for_file: unnecessary_this

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class PrintBitmapSpy extends Mock implements PrintBitmap {
  PrintBitmapSpy() {
    this._mockPrintBitmap();
  }
  When _mocPrintBitmapCall() => when(() => this.print(any()));

  void _mockPrintBitmap() {
    this._mocPrintBitmapCall().thenAnswer((any) async => any);
  }

  void mockPrintBitmapError() {
    this._mocPrintBitmapCall().thenThrow(DomainError.unexpected);
  }
}
