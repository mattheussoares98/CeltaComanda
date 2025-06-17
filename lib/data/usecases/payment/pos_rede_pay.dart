import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/usecases/usecases.dart';
import '../../mixins/mixins.dart';
import '../../models/models.dart';

class PosRedePay with ErrorHandling implements RedePay {
  @override
  Future<void> pay(PayParamsModel params) async {
    final platform = MethodChannel("rede");

    try {
      final result = await platform.invokeMethod(
        params.paymentMode.name,
        params.toJson(),
      );

      debugPrint(result);
    } catch (e) {
      treatError(e);
    }
  }
}
