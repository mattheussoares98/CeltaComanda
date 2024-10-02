// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import 'entities.dart';

class UpdateSaleRequestTempEntity extends Equatable {
  final String? Comments;
  final int? DeliveryControl;
  final int EnterpriseId;
  final String PersonalizedCode;
  final int SaleRequestTempId;
  final double TotalLiquid;
  final int? Peoples;
  final String? SellerCode;
  final List<UpdateSaleRequestTempProductEntity> Products;
  final int? CustomerCode;
  final int? CovenantCode;

  const UpdateSaleRequestTempEntity({
    required this.Comments,
    required this.Peoples,
    required this.DeliveryControl,
    required this.EnterpriseId,
    required this.PersonalizedCode,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Products,
    required this.SellerCode,
    required this.CustomerCode,
    required this.CovenantCode,
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
        Peoples,
        SellerCode,
        CustomerCode,
        CovenantCode,
      ];
}
