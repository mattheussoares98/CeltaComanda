import 'dart:typed_data';

abstract class PrintBitmap {
  Future<void> print(Uint8List bitmap);
}
