import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/helpers/helpers.dart';

class CameraBarcodeScanner implements BarcodeScanner {
  @override
  Future<String> read() async {
    try {
      String barcodeScanRes = "";
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        R.string.cancel,
        true,
        ScanMode.BARCODE,
      );

      if (barcodeScanRes != '-1') {
        return barcodeScanRes;
      } else {
        return "";
      }
    } on DomainError catch (e) {
      if (e == DomainError.unexpected) {
        throw DomainError.unexpected;
      } else {
        throw DomainError.barcodeNotRead;
      }
    }
  }
}
