// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../data/models/models.dart';

class SaleRequestTempViewModel extends Equatable {
  final List<ProductModel> Products;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int DeliveryControl;
  final String? Comments;

  @override
  List get props => [
        Products,
        PersonalizedCode,
        EnterpriseId,
        TotalLiquid,
        DeliveryControl,
        Comments,
      ];

  const SaleRequestTempViewModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
  });
}
