import 'package:flutter/services.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class PosPay implements Pay {
  @override
  Future<void> pay({
    required PaymentMode paymentMode,
    required PayParams params,
    required Channels channel,
  }) async {
    final platform = MethodChannel(channel.name);

    try {
      final result = await platform.invokeMethod(
        paymentMode.name,
        PosPayParams.fromDomain(params).toJson(),
      );

      // ignore: avoid_print
      print((result));
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

class PosPayParams {
  final int longAmountValue;
  final int portionQuantity;

  PosPayParams({
    required this.longAmountValue,
    required this.portionQuantity,
  });

  factory PosPayParams.fromDomain(PayParams params) => PosPayParams(
        longAmountValue: params.longAmountValue,
        portionQuantity: params.portionQuantity,
      );

  Map toJson() => {
        'longAmountValue': longAmountValue,
        'portionQuantity': portionQuantity,
      };
}
