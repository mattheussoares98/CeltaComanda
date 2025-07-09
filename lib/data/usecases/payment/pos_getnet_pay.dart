import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/usecases/usecases.dart';
import '../../models/models.dart';

class PosGetnetPay implements GetnetPay {
  @override
  Future<GetNetResponseModel?> pay(PayParamsModel params) async {
    try {
      const int requestCode = 10001;
      // final String ARG_RESULT = 'result';
      // final String ARG_RESULT_DETAILS = 'resultDetails';
      // final String ARG_AMOUNT = 'amount';
      // final String ARG_TYPE = 'type';
      // final String ARG_INPUT_TYPE = 'inputType';
      // final String ARG_INSTALLMENTS = 'installments';
      // final String ARG_NSU = 'nsu';
      // final String ARG_BRAND = 'brand';
      // final String ARG_CALLER_ID = 'callerId';
      const String paramPaymentType = 'paymentType';
      const String paramAmount = 'amount';
      const String paramCurPos = 'currencyPosition';
      const String paramCurCode = 'currencyCode';
      const String paramCallerId = 'callerId';

      const channel = MethodChannel('sample.android/deeplink');

      var uuid = const Uuid();
      String callerId = uuid.v4();

      final totalAmount = params.longAmountValue
          .toString()
          .replaceAll(RegExp(r','), '')
          .replaceAll(RegExp(r'\.'), '')
          .padLeft(12, "0");

      Map<String, String> intentParams = {
        paramPaymentType: params.paymentMode.name,
        paramAmount: totalAmount,
        paramCurPos: 'CURRENCY_AFTER_AMOUNT',
        paramCurCode: '986',
        paramCallerId: callerId
      };

      final parameters = {
        'requestCode': requestCode,
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

        return GetNetResponseModel.fromJson(resultMap);
      }
    } catch (e) {
      debugPrint('Error launching intent: $e');
      return null;
    }
    return null;
  }
}
