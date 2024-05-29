import 'package:clean_celta_mobile/domain/helpers/helpers.dart';
import 'package:flutter/services.dart';

import '../../../domain/usecases/usecases.dart';

class RedePay implements Pay {
  @override
  Future<void> pay({
    required PaymantMode paymentMode,
    required PayParams params,
  }) async {
    const platform = MethodChannel('rede_channel');

    try {
      await platform.invokeMethod(
        paymentMode.name,
        RedePayParams.fromDomain(params).toJson(),
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

class RedePayParams {
  final int longAmountValue;
  final int portionQuantity;

  RedePayParams({
    required this.longAmountValue,
    required this.portionQuantity,
  });

  factory RedePayParams.fromDomain(PayParams params) => RedePayParams(
        longAmountValue: params.longAmountValue,
        portionQuantity: params.portionQuantity,
      );

  Map toJson() => {
        'longAmountValue': longAmountValue,
        'portionQuantity': portionQuantity,
      };
}
