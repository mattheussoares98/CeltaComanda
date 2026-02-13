// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../entities.dart';
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

  ConcSaleRequestEntity copyWith({
    int? SaleRequestId,
    String? PersonalizedCode,
    String? Comments,
    DateTime? DateHourOfCreation,
    DateTime? DateOfCreation,
    bool? IsCancelled,
    bool? IsUsing,
    double? TotalLiquid,
    List<ConcSaleRequestProductEntity>? Products,
    int? EnterpriseId,
    SaleRequestOriginType? FlagOrigin,
    int? EnterpriseCode,
    String? enterprisePersonalizedCode,
    int? InternalCodeOnERP,
    int? CustomerCode,
    String? CpfCnpjNumber,
    String? CustomerName,
    int? CustomerAdditionalCode,
    String? CustomerAdditionalName,
    int? CovenantCode,
    String? CovenantName,
    int? IncrementType,
    double? IncrementValue,
    String? SellerCode,
    String? SellerName,
    int? DeliveryControl,
    bool? HasServices,
    IsToDelivery? isToDelivery,
    DateTime? DateHourOfDelivery,
    String? PersonalizedCodeReduced,
  }) {
    return ConcSaleRequestEntity(
      SaleRequestId: SaleRequestId ?? this.SaleRequestId,
      PersonalizedCode: PersonalizedCode ?? this.PersonalizedCode,
      Comments: Comments ?? this.Comments,
      DateHourOfCreation: DateHourOfCreation ?? this.DateHourOfCreation,
      DateOfCreation: DateOfCreation ?? this.DateOfCreation,
      IsCancelled: IsCancelled ?? this.IsCancelled,
      IsUsing: IsUsing ?? this.IsUsing,
      TotalLiquid: TotalLiquid ?? this.TotalLiquid,
      Products: Products ?? this.Products,
      EnterpriseId: EnterpriseId ?? this.EnterpriseId,
      FlagOrigin: FlagOrigin ?? this.FlagOrigin,
      EnterpriseCode: EnterpriseCode ?? this.EnterpriseCode,
      enterprisePersonalizedCode:
          enterprisePersonalizedCode ?? this.enterprisePersonalizedCode,
      InternalCodeOnERP: InternalCodeOnERP ?? this.InternalCodeOnERP,
      CustomerCode: CustomerCode ?? this.CustomerCode,
      CpfCnpjNumber: CpfCnpjNumber ?? this.CpfCnpjNumber,
      CustomerName: CustomerName ?? this.CustomerName,
      CustomerAdditionalCode:
          CustomerAdditionalCode ?? this.CustomerAdditionalCode,
      CustomerAdditionalName:
          CustomerAdditionalName ?? this.CustomerAdditionalName,
      CovenantCode: CovenantCode ?? this.CovenantCode,
      CovenantName: CovenantName ?? this.CovenantName,
      IncrementType: IncrementType ?? this.IncrementType,
      IncrementValue: IncrementValue ?? this.IncrementValue,
      SellerCode: SellerCode ?? this.SellerCode,
      SellerName: SellerName ?? this.SellerName,
      DeliveryControl: DeliveryControl ?? this.DeliveryControl,
      HasServices: HasServices ?? this.HasServices,
      isToDelivery: isToDelivery ?? this.isToDelivery,
      DateHourOfDelivery: DateHourOfDelivery ?? this.DateHourOfDelivery,
      PersonalizedCodeReduced:
          PersonalizedCodeReduced ?? this.PersonalizedCodeReduced,
    );
  }
}

enum SaleRequestOriginType {
  bs(1),
  concentrator(2),
  all(3);

  final int code;
  const SaleRequestOriginType(this.code);
}
