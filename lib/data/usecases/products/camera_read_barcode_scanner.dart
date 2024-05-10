import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../domain/usecases/usecases.dart';

class CameraReadBarcodeScanner implements ReadBarcodeScanner {
  @override
  Future<String> read() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (barcodeScanRes != '-1') {
      return barcodeScanRes;
    } else {
      return "";
    }
  }
}
