import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/usecases/usecases.dart';
import '../../models/models.dart';

class PosGetnetPay implements GetnetPay {
  @override
  Future<Map<String, dynamic>?> pay(PayParamsModel params) async {
    try {
      final int REQUEST_CODE = 10001;
      // final String ARG_RESULT = 'result';
      // final String ARG_RESULT_DETAILS = 'resultDetails';
      // final String ARG_AMOUNT = 'amount';
      // final String ARG_TYPE = 'type';
      // final String ARG_INPUT_TYPE = 'inputType';
      // final String ARG_INSTALLMENTS = 'installments';
      // final String ARG_NSU = 'nsu';
      // final String ARG_BRAND = 'brand';
      // final String ARG_CALLER_ID = 'callerId';
      final String PARAM_PAYMENT_TYPE = 'paymentType';
      final String PARAM_AMOUNT = 'amount';
      final String PARAM_CUR_POS = 'currencyPosition';
      final String PARAM_CUR_CODE = 'currencyCode';
      final String PARAM_CALLER_ID = 'callerId';

      final channel = MethodChannel('sample.android/deeplink');

      var uuid = Uuid();
      String callerId = uuid.v4();

      final totalAmount = params.longAmountValue
          .toString()
          .replaceAll(RegExp(r','), '')
          .replaceAll(RegExp(r'\.'), '')
          .padLeft(12, "0");

      Map<String, String> intentParams = {
        PARAM_PAYMENT_TYPE: params.paymentMode.name,
        PARAM_AMOUNT: totalAmount, //TODO test this
        PARAM_CUR_POS: 'CURRENCY_AFTER_AMOUNT',
        PARAM_CUR_CODE: '986',
        PARAM_CALLER_ID: callerId
      };

      final parameters = {
        'requestCode': REQUEST_CODE,
        'action': 'android.intent.action.VIEW',
        'data': 'getnet://pagamento/v3/payment',
        'arguments': intentParams,
      };
      var result =
          await channel.invokeMethod('startActivityForResult', parameters);

      if (result != null) {
        var resultMap = Map<String, dynamic>.from(result);

        // String resultValue = resultMap[ARG_RESULT];
        // String resultDetails = resultMap[ARG_RESULT_DETAILS];
        // String amount = resultMap[ARG_AMOUNT];
        // String type = resultMap[ARG_TYPE];
        // String inputType = resultMap[ARG_INPUT_TYPE];
        // String installments = resultMap[ARG_INSTALLMENTS];
        // String nsu = resultMap[ARG_NSU];
        // String brand = resultMap[ARG_BRAND];
        // String callerId = resultMap[ARG_CALLER_ID];

        return resultMap;
      }
    } catch (e) {
      debugPrint('Error launching intent: $e');
      return null;
    }
    return null;
  }
}
