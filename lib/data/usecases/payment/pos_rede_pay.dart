import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../models/models.dart';

class PosRedePay implements RedePay {
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
      throw DomainError.unexpected;
    }
  }
}
