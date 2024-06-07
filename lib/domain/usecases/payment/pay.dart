import 'package:equatable/equatable.dart';

import '../../helpers/helpers.dart';

abstract class Pay {
  Future<void> pay({
    required PaymentMode paymentMode,
    required PayParams params,
  });
}

class PayParams extends Equatable {
  final int longAmountValue;
  final int portionQuantity;

  @override
  List get props => [longAmountValue, portionQuantity];

  const PayParams({
    required this.longAmountValue,
    required this.portionQuantity,
  });
}
