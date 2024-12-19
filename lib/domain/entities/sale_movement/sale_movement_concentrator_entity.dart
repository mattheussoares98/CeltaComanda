// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../entities.dart';

class SaleMovementConcentratorEntity extends Equatable {
  final int? SaleMovementId;
  final int? PdvId;
  final String? PdvNumber;
  final int? CashierMovementId;
  final int? EnterpriseId;
  final int? EnterpriseCode;
  final String? PersonalizedCode;
  final int? CouponFiscalNumber;
  final String? DateOfCreation;
  final String? DateHourOfCreation;
  final String? CpfCnpj;
  final int? DiscountType;
  final double? DiscountValue;
  final int? UserIdOfDiscount;
  final double? DiscountFinalizationValue;
  final String? CRMDiscountTransactionId;
  final String? CRMCpfCnpj;
  final int? CRMDiscountType;
  final double? CRMDiscountValue;
  final int? IncrementType;
  final double? IncrementValue;
  final double? FidelityControlsPoints;
  final String? XmlSatNfce;
  final String? XmlSatNfceCancel;
  final String? EletronicAccessKey;
  final String? SaleRequestPersonalizedCode;
  final int? SaleFiscalType;
  final int? SalePricePraticed;
  final String? SaleFiscalTypeString;
  final int? UserIdOfCancellation;
  final bool? IsCancelled;
  final int? IsToDelivery;
  final bool? IsForTravel;
  final String? DateHourOfDelivery;
  final int? DeliveryControl;
  final bool? WasPrinted;
  final int? MotiveJustificationId;
  final String? MotiveJustificationName;
  final int? MotiveJustificationSaleDiscountId;
  final String? MotiveJustificationSaleDiscountName;
  final bool? IsDelivery;
  final int? CovenantCode;
  final int? CustomerCode;
  final int? CustomerAdditionalCode;
  final int? SellerCode;
  final String? SellerName;
  final double? TotalLiquid;
  final List<SaleMovementProductConcentratorEntity> Products;
  final List<SaleMovementConcentratorFinalizationEntity> Finalizations;

  const SaleMovementConcentratorEntity({
    required this.SaleMovementId,
    required this.PdvId,
    required this.PdvNumber,
    required this.CashierMovementId,
    required this.EnterpriseId,
    required this.EnterpriseCode,
    required this.PersonalizedCode,
    required this.CouponFiscalNumber,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.CpfCnpj,
    required this.DiscountType,
    required this.DiscountValue,
    required this.UserIdOfDiscount,
    required this.DiscountFinalizationValue,
    required this.CRMDiscountTransactionId,
    required this.CRMCpfCnpj,
    required this.CRMDiscountType,
    required this.CRMDiscountValue,
    required this.IncrementType,
    required this.IncrementValue,
    required this.FidelityControlsPoints,
    required this.XmlSatNfce,
    required this.XmlSatNfceCancel,
    required this.EletronicAccessKey,
    required this.SaleRequestPersonalizedCode,
    required this.SaleFiscalType,
    required this.SalePricePraticed,
    required this.SaleFiscalTypeString,
    required this.UserIdOfCancellation,
    required this.IsCancelled,
    required this.IsToDelivery,
    required this.IsForTravel,
    required this.DateHourOfDelivery,
    required this.DeliveryControl,
    required this.WasPrinted,
    required this.MotiveJustificationId,
    required this.MotiveJustificationName,
    required this.MotiveJustificationSaleDiscountId,
    required this.MotiveJustificationSaleDiscountName,
    required this.IsDelivery,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.CustomerAdditionalCode,
    required this.SellerCode,
    required this.SellerName,
    required this.TotalLiquid,
    required this.Products,
    required this.Finalizations,
  });

  @override
  List<Object?> get props => [
        SaleMovementId,
        PdvId,
        PdvNumber,
        CashierMovementId,
        EnterpriseId,
        EnterpriseCode,
        PersonalizedCode,
        CouponFiscalNumber,
        DateOfCreation,
        DateHourOfCreation,
        CpfCnpj,
        DiscountType,
        DiscountValue,
        UserIdOfDiscount,
        DiscountFinalizationValue,
        CRMDiscountTransactionId,
        CRMCpfCnpj,
        CRMDiscountType,
        CRMDiscountValue,
        IncrementType,
        IncrementValue,
        FidelityControlsPoints,
        XmlSatNfce,
        XmlSatNfceCancel,
        EletronicAccessKey,
        SaleRequestPersonalizedCode,
        SaleFiscalType,
        SalePricePraticed,
        SaleFiscalTypeString,
        UserIdOfCancellation,
        IsCancelled,
        IsToDelivery,
        IsForTravel,
        DateHourOfDelivery,
        DeliveryControl,
        WasPrinted,
        MotiveJustificationId,
        MotiveJustificationName,
        MotiveJustificationSaleDiscountId,
        MotiveJustificationSaleDiscountName,
        IsDelivery,
        CovenantCode,
        CustomerCode,
        CustomerAdditionalCode,
        SellerCode,
        SellerName,
        TotalLiquid,
        Products,
        Finalizations,
      ];
}
