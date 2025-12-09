import 'package:equatable/equatable.dart';

import '../../../domain/entities/conc_sale_request/conc_sale_request.dart';
import 'conc_sale_request_product_model.dart';

class ConcSaleRequestModel extends Equatable {
  final int SaleRequestId;
  final String PersonalizedCode;
  final String? Comments;
  final DateTime DateHourOfCreation;
  final DateTime DateOfCreation;
  final bool IsCancelled;
  final bool IsUsing;
  final double TotalLiquid;
  final List<ConcSaleRequestProductModel> Products;
  final int EnterpriseId;
  final SaleRequestOriginType FlagOrigin;
  final int EnterpriseCode;
  final String EnterprisePersonalizedCode;
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
  final int? IsToDelivery;
  final DateTime? DateHourOfDelivery;
  final String? PersonalizedCodeReduced;
  // final ModelEnterprise Enterprise ;

  const ConcSaleRequestModel({
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
    required this.EnterprisePersonalizedCode,
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
    required this.IsToDelivery,
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
        EnterprisePersonalizedCode,
        InternalCodeOnERP,
        CustomerCode,
        CpfCnpjNumber,
        CustomerName,
        CustomerAdditionalCode,
        CustomerAdditionalName,
        CovenantCode,
      ];

  factory ConcSaleRequestModel.fromEntity(ConcSaleRequestEntity entity) =>
      ConcSaleRequestModel(
        SaleRequestId: entity.SaleRequestId,
        PersonalizedCode: entity.PersonalizedCode,
        Comments: entity.Comments,
        DateHourOfCreation: entity.DateHourOfCreation,
        DateOfCreation: entity.DateOfCreation,
        IsCancelled: entity.IsCancelled,
        IsUsing: entity.IsUsing,
        TotalLiquid: entity.TotalLiquid,
        Products: entity.Products.map(
            (e) => ConcSaleRequestProductModel.fromEntity(e)).toList(),
        EnterpriseId: entity.EnterpriseId,
        FlagOrigin: entity.FlagOrigin,
        EnterpriseCode: entity.EnterpriseCode,
        EnterprisePersonalizedCode: entity.enterprisePersonalizedCode,
        InternalCodeOnERP: entity.InternalCodeOnERP,
        CustomerCode: entity.CustomerCode,
        CpfCnpjNumber: entity.CpfCnpjNumber,
        CustomerName: entity.CustomerName,
        CustomerAdditionalCode: entity.CustomerAdditionalCode,
        CustomerAdditionalName: entity.CustomerAdditionalName,
        CovenantCode: entity.CovenantCode,
        CovenantName: entity.CovenantName,
        IncrementType: entity.IncrementType,
        IncrementValue: entity.IncrementValue,
        SellerCode: entity.SellerCode,
        SellerName: entity.SellerName,
        DeliveryControl: entity.DeliveryControl,
        HasServices: entity.HasServices,
        IsToDelivery: entity.IsToDelivery,
        DateHourOfDelivery: entity.DateHourOfDelivery,
        PersonalizedCodeReduced: entity.PersonalizedCodeReduced,
      );

  ConcSaleRequestEntity toEntity() => ConcSaleRequestEntity(
        SaleRequestId: SaleRequestId,
        PersonalizedCode: PersonalizedCode,
        Comments: Comments,
        DateHourOfCreation: DateHourOfCreation,
        DateOfCreation: DateOfCreation,
        IsCancelled: IsCancelled,
        IsUsing: IsUsing,
        TotalLiquid: TotalLiquid,
        Products: Products.map((e) => e.toEntity()).toList(),
        EnterpriseId: EnterpriseId,
        FlagOrigin: FlagOrigin,
        EnterpriseCode: EnterpriseCode,
        enterprisePersonalizedCode: EnterprisePersonalizedCode,
        InternalCodeOnERP: InternalCodeOnERP,
        CustomerCode: CustomerCode,
        CpfCnpjNumber: CpfCnpjNumber,
        CustomerName: CustomerName,
        CustomerAdditionalCode: CustomerAdditionalCode,
        CustomerAdditionalName: CustomerAdditionalName,
        CovenantCode: CovenantCode,
        CovenantName: CovenantName,
        IncrementType: IncrementType,
        IncrementValue: IncrementValue,
        SellerCode: SellerCode,
        SellerName: SellerName,
        DeliveryControl: DeliveryControl,
        HasServices: HasServices,
        IsToDelivery: IsToDelivery,
        DateHourOfDelivery: DateHourOfDelivery,
        PersonalizedCodeReduced: PersonalizedCodeReduced,
      );

  factory ConcSaleRequestModel.fromJson(Map json) => ConcSaleRequestModel(
        SaleRequestId: json['SaleRequestId'],
        PersonalizedCode: json['PersonalizedCode'],
        Comments: json['Comments'],
        DateHourOfCreation: DateTime.parse(json['DateHourOfCreation']),
        DateOfCreation: DateTime.parse(json['DateOfCreation']),
        IsCancelled: json['IsCancelled'],
        IsUsing: json['IsUsing'],
        TotalLiquid: json['TotalLiquid'],
        Products: (json['Products'] as List)
            .map((e) => ConcSaleRequestProductModel.fromJson(e))
            .toList(),
        EnterpriseId: json['EnterpriseId'],
        FlagOrigin: SaleRequestOriginType.values
            .firstWhere((e) => e.code == json['FlagOrigin']),
        EnterpriseCode: json['EnterpriseCode'],
        EnterprisePersonalizedCode: json['EnterprisePersonalizedCode'],
        InternalCodeOnERP: json['InternalCodeOnERP'],
        CustomerCode: json['CustomerCode'],
        CpfCnpjNumber: json['CpfCnpjNumber'],
        CustomerName: json['CustomerName'],
        CustomerAdditionalCode: json['CustomerAdditionalCode'],
        CustomerAdditionalName: json['CustomerAdditionalName'],
        CovenantCode: json['CovenantCode'],
        CovenantName: json['CovenantName'],
        IncrementType: json['IncrementType'],
        IncrementValue: json['IncrementValue'],
        SellerCode: json['SellerCode'],
        SellerName: json['SellerName'],
        DeliveryControl: json['DeliveryControl'],
        HasServices: json['HasServices'],
        IsToDelivery: json['IsToDelivery'],
        DateHourOfDelivery: json['DateHourOfDelivery'] == null
            ? null
            : DateTime.parse(json['DateHourOfDelivery']),
        PersonalizedCodeReduced: json['PersonalizedCodeReduced'],
      );
}
