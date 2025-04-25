import 'package:equatable/equatable.dart';

import '../../domain/helpers/helpers.dart';

class PayParamsModel extends Equatable {
  final int longAmountValue;
  final int portionQuantity;
  final PaymentMode paymentMode;

  const PayParamsModel({
    required this.longAmountValue,
    required this.portionQuantity,
    required this.paymentMode,
  });

  @override
  List<Object?> get props => [
        longAmountValue,
        portionQuantity,
        paymentMode,
      ];

  Map toJson() => {
        'longAmountValue': longAmountValue,
        'portionQuantity': portionQuantity,
        'paymentMode': paymentMode.name,
      };
}
