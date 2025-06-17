import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/helpers/helpers.dart';
import '../../mixins/mixins.dart';

class CameraBarcodeScanner with ErrorHandling implements BarcodeScanner {
  @override
  Future<String> read() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        R.string.cancel,
        true,
        ScanMode.BARCODE,
      );

      if (barcodeScanRes == "-1") {
        throw DomainError.barcodeNotRead;
      }

      return barcodeScanRes;
    } catch (e) {
      treatError(e);
    }
  }
}
