import 'package:equatable/equatable.dart';

import '../models.dart';

class SelectedCustomerModel extends Equatable {
  final CustomerModel customer;
  final int? covenantCode;

  const SelectedCustomerModel({
    required this.customer,
    required this.covenantCode,
  });

  @override
  List<Object?> get props => [customer, covenantCode];
}
