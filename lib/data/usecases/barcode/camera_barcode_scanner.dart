import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class CameraBarcodeScanner implements BarcodeScanner {
  @override
  Future<String> read() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    } catch (e) {
      throw DomainError.unexpected;
    }

    if (barcodeScanRes != '-1') {
      return barcodeScanRes;
    } else {
      return "";
    }
  }
}
