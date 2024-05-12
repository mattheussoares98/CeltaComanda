// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import 'entities.dart';

class UpdateSaleRequestTempEntity extends Equatable {
  final String? Comments;
  final int DeliveryControl;
  final int EnterpriseId;
  final String PersonalizedCode;
  final int SaleRequestTempId;
  final double TotalLiquid;
  final List<UpdateSaleRequestTempProductEntity> Products;

  const UpdateSaleRequestTempEntity({
    this.Comments,
    required this.DeliveryControl,
    required this.EnterpriseId,
    required this.PersonalizedCode,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Products,
  });

  @override
  List<Object?> get props => [
        Comments,
        DeliveryControl,
        EnterpriseId,
        PersonalizedCode,
        SaleRequestTempId,
        TotalLiquid,
        Products,
      ];
}
