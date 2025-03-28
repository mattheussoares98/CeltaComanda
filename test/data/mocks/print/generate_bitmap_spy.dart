// ignore_for_file: unnecessary_this

import 'dart:typed_data';

import 'package:clean_celta_mobile/domain/helpers/domain_error.dart';
import 'package:clean_celta_mobile/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class GenerateBitmapSpy extends Mock implements GenerateBitmap {
  When _mocGenerateBytesCall() => when(() => this.generate(
        commandNumber: any(named: "commandNumber"),
        pdvNumber: any(named: "pdvNumber"),
        printed: any(named: "printed"),
        subTotal: any(named: "subTotal"),
        serviceChargeValue: any(named: "serviceChargeValue"),
        totalLiquid: any(named: "totalLiquid"),
        peopleQuantity: any(named: "peopleQuantity"),
      ));

  void mockGenerateBytes(Uint8List bytes) {
    this._mocGenerateBytesCall().thenAnswer((any) async => bytes);
  }

  void mockGenerateBytesError() {
    this._mocGenerateBytesCall().thenThrow(DomainError.unexpected);
  }
}
