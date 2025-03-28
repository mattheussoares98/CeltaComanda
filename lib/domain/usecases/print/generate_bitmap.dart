import 'dart:typed_data';

import '../../../ui/pages/pages.dart';

abstract class GenerateBitmap {
  Future<Uint8List> generate({
    required int commandNumber,
    required int pdvNumber,
    required PrintedViewModel printed,
    required double subTotal,
    required double? serviceChargeValue,
    required double totalLiquid,
    required int peopleQuantity,
  });
}
