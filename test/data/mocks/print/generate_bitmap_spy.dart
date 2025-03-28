// ignore_for_file: unnecessary_this

import 'dart:typed_data';

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class GenerateBitmapSpy extends Mock implements GenerateBitmap {
  When _mockGenerateBitmapCall() => when(() => this.generate(
        commandNumber: any(named: "commandNumber"),
        pdvNumber: any(named: "pdvNumber"),
        printed: any(named: "printed"),
        subTotal: any(named: "subTotal"),
        serviceChargeValue: any(named: "serviceChargeValue"),
        totalLiquid: any(named: "totalLiquid"),
        peopleQuantity: any(named: "peopleQuantity"),
      ));

  void mockGenerateBitmap(Uint8List bytes) {
    this._mockGenerateBitmapCall().thenAnswer((any) async => bytes);
  }

  void mockGenerateBitmapError() {
    this._mockGenerateBitmapCall().thenThrow(DomainError.unexpected);
  }
}
