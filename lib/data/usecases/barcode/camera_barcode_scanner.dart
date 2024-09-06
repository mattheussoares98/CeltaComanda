import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class CameraBarcodeScanner implements BarcodeScanner {
  @override
  Future<String> read() async {
    String barcodeScanRes = "";
    try {
      AiBarcodeScanner(
        onDetect: (BarcodeCapture barcodeCapture) {
          final String? scannedValue =
              barcodeCapture.barcodes.first.displayValue;

          if (scannedValue != null) {
            barcodeScanRes = scannedValue;
          } else {
            throw DomainError.barcodeNotRead;
          }
        },
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        validator: (value) {
          if (value.barcodes.isEmpty) {
            return false;
          }

          return true;
        },
      );
      return barcodeScanRes;
    } on DomainError catch (e) {
      if (e == DomainError.unexpected) {
        throw DomainError.unexpected;
      } else {
        throw DomainError.barcodeNotRead;
      }
    }
  }
}
