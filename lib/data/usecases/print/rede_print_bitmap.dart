import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class RedePrintBitmap implements PrintBitmap {
  @override
  Future<void> print(Uint8List bitmap) async {
    try {
      final platform = MethodChannel(Channels.redePrinter.name);

      final result = await platform.invokeMethod(
        "printBitmap",
        {"bitmap": bitmap},
      );

      debugPrint((result));
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
