// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../models.dart';

class SaleMovementConcentratorModel extends Equatable {
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
  final List<SaleMovementProductConcentratorModel> Products;
  final List<SaleMovementConcentratorFinalizationModel> Finalizations;

  const SaleMovementConcentratorModel({
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

  factory SaleMovementConcentratorModel.fromJson(Map data) =>
      SaleMovementConcentratorModel(
        SaleMovementId: data["SaleMovementId"],
        PdvId: data["PdvId"],
        PdvNumber: data["PdvNumber"],
        CashierMovementId: data["CashierMovementId"],
        EnterpriseId: data["EnterpriseId"],
        EnterpriseCode: data["EnterpriseCode"],
        PersonalizedCode: data["PersonalizedCode"],
        CouponFiscalNumber: data["CouponFiscalNumber"],
        DateOfCreation: data["DateOfCreation"],
        DateHourOfCreation: data["DateHourOfCreation"],
        CpfCnpj: data["CpfCnpj"],
        DiscountType: data["DiscountType"],
        DiscountValue: data["DiscountValue"],
        UserIdOfDiscount: data["UserIdOfDiscount"],
        DiscountFinalizationValue: data["DiscountFinalizationValue"],
        CRMDiscountTransactionId: data["CRMDiscountTransactionId"],
        CRMCpfCnpj: data["CRMCpfCnpj"],
        CRMDiscountType: data["CRMDiscountType"],
        CRMDiscountValue: data["CRMDiscountValue"],
        IncrementType: data["IncrementType"],
        IncrementValue: data["IncrementValue"],
        FidelityControlsPoints: data["FidelityControlsPoints"],
        XmlSatNfce: data["XmlSatNfce"],
        XmlSatNfceCancel: data["XmlSatNfceCancel"],
        EletronicAccessKey: data["EletronicAccessKey"],
        SaleRequestPersonalizedCode: data["SaleRequestPersonalizedCode"],
        SaleFiscalType: data["SaleFiscalType"],
        SalePricePraticed: data["SalePricePraticed"],
        SaleFiscalTypeString: data["SaleFiscalTypeString"],
        UserIdOfCancellation: data["UserIdOfCancellation"],
        IsCancelled: data["IsCancelled"],
        IsToDelivery: data["IsToDelivery"],
        IsForTravel: data["IsForTravel"],
        DateHourOfDelivery: data["DateHourOfDelivery"],
        DeliveryControl: data["DeliveryControl"],
        WasPrinted: data["WasPrinted"],
        MotiveJustificationId: data["MotiveJustificationId"],
        MotiveJustificationName: data["MotiveJustificationName"],
        MotiveJustificationSaleDiscountId:
            data["MotiveJustificationSaleDiscountId"],
        MotiveJustificationSaleDiscountName:
            data["MotiveJustificationSaleDiscountName"],
        IsDelivery: data["IsDelivery"],
        CovenantCode: data["CovenantCode"],
        CustomerCode: data["CustomerCode"],
        CustomerAdditionalCode: data["CustomerAdditionalCode"],
        SellerCode: data["SellerCode"],
        SellerName: data["SellerName"],
        TotalLiquid: data["TotalLiquid"],
        Products: data["Products"],
        Finalizations: data["Finalizations"],
      );

  Map<String, dynamic> toJson() => {
        "SaleMovementId": SaleMovementId,
        "PdvId": PdvId,
        "PdvNumber": PdvNumber,
        "CashierMovementId": CashierMovementId,
        "EnterpriseId": EnterpriseId,
        "EnterpriseCode": EnterpriseCode,
        "PersonalizedCode": PersonalizedCode,
        "CouponFiscalNumber": CouponFiscalNumber,
        "DateOfCreation": DateOfCreation,
        "DateHourOfCreation": DateHourOfCreation,
        "CpfCnpj": CpfCnpj,
        "DiscountType": DiscountType,
        "DiscountValue": DiscountValue,
        "UserIdOfDiscount": UserIdOfDiscount,
        "DiscountFinalizationValue": DiscountFinalizationValue,
        "CRMDiscountTransactionId": CRMDiscountTransactionId,
        "CRMCpfCnpj": CRMCpfCnpj,
        "CRMDiscountType": CRMDiscountType,
        "CRMDiscountValue": CRMDiscountValue,
        "IncrementType": IncrementType,
        "IncrementValue": IncrementValue,
        "FidelityControlsPoints": FidelityControlsPoints,
        "XmlSatNfce": XmlSatNfce,
        "XmlSatNfceCancel": XmlSatNfceCancel,
        "EletronicAccessKey": EletronicAccessKey,
        "SaleRequestPersonalizedCode": SaleRequestPersonalizedCode,
        "SaleFiscalType": SaleFiscalType,
        "SalePricePraticed": SalePricePraticed,
        "SaleFiscalTypeString": SaleFiscalTypeString,
        "UserIdOfCancellation": UserIdOfCancellation,
        "IsCancelled": IsCancelled,
        "IsToDelivery": IsToDelivery,
        "IsForTravel": IsForTravel,
        "DateHourOfDelivery": DateHourOfDelivery,
        "DeliveryControl": DeliveryControl,
        "WasPrinted": WasPrinted,
        "MotiveJustificationId": MotiveJustificationId,
        "MotiveJustificationName": MotiveJustificationName,
        "MotiveJustificationSaleDiscountId": MotiveJustificationSaleDiscountId,
        "MotiveJustificationSaleDiscountName":
            MotiveJustificationSaleDiscountName,
        "IsDelivery": IsDelivery,
        "CovenantCode": CovenantCode,
        "CustomerCode": CustomerCode,
        "CustomerAdditionalCode": CustomerAdditionalCode,
        "SellerCode": SellerCode,
        "SellerName": SellerName,
        "TotalLiquid": TotalLiquid,
        "Products": Products,
        "Finalizations": Finalizations,
      };
}
