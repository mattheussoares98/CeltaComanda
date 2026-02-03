import 'package:equatable/equatable.dart';

import 'conc_sale_request.dart';

class ConcSaleRequestEntity extends Equatable {
  final int SaleRequestId;
  final String PersonalizedCode;
  final String? Comments;
  final DateTime DateHourOfCreation;
  final DateTime DateOfCreation;
  final bool IsCancelled;
  final bool IsUsing;
  final double TotalLiquid;
  final List<ConcSaleRequestProductEntity> Products;
  final int EnterpriseId;
  final SaleRequestOriginType FlagOrigin;
  final int EnterpriseCode;
  final String enterprisePersonalizedCode;
  final int InternalCodeOnERP;
  final int CustomerCode;
  final String? CpfCnpjNumber;
  final String? CustomerName;
  final int? CustomerAdditionalCode;
  final String? CustomerAdditionalName;
  final int? CovenantCode;
  final String? CovenantName;
  final int? IncrementType;
  final double? IncrementValue;
  final String? SellerCode;
  final String? SellerName;
  final int? DeliveryControl;
  final bool? HasServices;
  final IsToDelivery? isToDelivery;
  final DateTime? DateHourOfDelivery;
  final String? PersonalizedCodeReduced;
  // final ModelEnterprise Enterprise ;

  const ConcSaleRequestEntity({
    required this.SaleRequestId,
    required this.PersonalizedCode,
    required this.Comments,
    required this.DateHourOfCreation,
    required this.DateOfCreation,
    required this.IsCancelled,
    required this.IsUsing,
    required this.TotalLiquid,
    required this.Products,
    required this.EnterpriseId,
    required this.FlagOrigin,
    required this.EnterpriseCode,
    required this.enterprisePersonalizedCode,
    required this.InternalCodeOnERP,
    required this.CustomerCode,
    required this.CpfCnpjNumber,
    required this.CustomerName,
    required this.CustomerAdditionalCode,
    required this.CustomerAdditionalName,
    required this.CovenantCode,
    required this.CovenantName,
    required this.IncrementType,
    required this.IncrementValue,
    required this.SellerCode,
    required this.SellerName,
    required this.DeliveryControl,
    required this.HasServices,
    required this.isToDelivery,
    required this.DateHourOfDelivery,
    required this.PersonalizedCodeReduced,
  });

  @override
  List<Object?> get props => [
        SaleRequestId,
        PersonalizedCode,
        Comments,
        DateHourOfCreation,
        DateOfCreation,
        IsCancelled,
        IsUsing,
        TotalLiquid,
        Products,
        EnterpriseId,
        FlagOrigin,
        EnterpriseCode,
        enterprisePersonalizedCode,
        InternalCodeOnERP,
        CustomerCode,
        CpfCnpjNumber,
        CustomerName,
        CustomerAdditionalCode,
        CustomerAdditionalName,
        CovenantCode,
      ];
}

enum SaleRequestOriginType {
  bs(1),
  concentrator(2),
  all(3);

  final int code;
  const SaleRequestOriginType(this.code);
}
