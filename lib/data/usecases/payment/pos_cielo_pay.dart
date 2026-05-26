import 'package:flutter/services.dart';

import '../../../domain/usecases/usecases.dart';
import '../../models/models.dart';

class PosCieloPay implements CieloPay {
  @override
  Future<Map<String, dynamic>?> pay(PayParamsModel params) async {
    try {
      const channel = MethodChannel('cielo');

      final totalAmount = params.longAmountValue.toString();

      final Map<String, dynamic> arguments = {
        'value': totalAmount,
        'paymentCode': params.paymentMode.name,
        'installments': params.portionQuantity,
        'callbackScheme': 'order',
        'callbackHost': 'response',
      };

      final result = await channel.invokeMethod('pay', arguments);

      if (result != null) {
        return Map<String, dynamic>.from(result);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
