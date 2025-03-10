

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../models.dart';

class SaleMovementConcentratorModel extends Equatable {
  final String? PdvNumber;
  final String? PersonalizedCode;
  final String? DateOfCreation;
  final String? DateHourOfCreation;
  final String? CpfCnpj;
  final String? CRMDiscountTransactionId;
  final String? CRMCpfCnpj;
  final String? XmlSatNfce;
  final String? XmlSatNfceCancel;
  final String? EletronicAccessKey;
  final String? SaleRequestPersonalizedCode;
  final String? SaleFiscalTypeString;
  final String? DateHourOfDelivery;
  final String? MotiveJustificationName;
  final String? MotiveJustificationSaleDiscountName;
  final String? SellerName;
  final int? SaleMovementId;
  final int? PdvId;
  final int? CashierMovementId;
  final int? EnterpriseId;
  final int? EnterpriseCode;
  final int? CouponFiscalNumber;
  final int? DiscountType;
  final int? UserIdOfDiscount;
  final int? CRMDiscountType;
  final int? IncrementType;
  final int? SaleFiscalType;
  final int? SalePricePraticed;
  final int? UserIdOfCancellation;
  final int? IsToDelivery;
  final int? DeliveryControl;
  final int? MotiveJustificationId;
  final int? MotiveJustificationSaleDiscountId;
  final int? CovenantCode;
  final int? CustomerCode;
  final int? CustomerAdditionalCode;
  final int? SellerCode;
  final double? DiscountValue;
  final double? DiscountFinalizationValue;
  final double? CRMDiscountValue;
  final double? IncrementValue;
  final double? FidelityControlsPoints;
  final double? TotalLiquid;
  final bool? IsCancelled;
  final bool? IsForTravel;
  final bool? WasPrinted;
  final bool? IsDelivery;
  final List<SaleMovementProductConcentratorModel> Products;
  final List<SaleMovementConcentratorFinalizationModel> Finalizations;

  const SaleMovementConcentratorModel({
    required this.PdvNumber,
    required this.PersonalizedCode,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.CpfCnpj,
    required this.CRMDiscountTransactionId,
    required this.CRMCpfCnpj,
    required this.XmlSatNfce,
    required this.XmlSatNfceCancel,
    required this.EletronicAccessKey,
    required this.SaleRequestPersonalizedCode,
    required this.SaleFiscalTypeString,
    required this.DateHourOfDelivery,
    required this.MotiveJustificationName,
    required this.MotiveJustificationSaleDiscountName,
    required this.SellerName,
    required this.SaleMovementId,
    required this.PdvId,
    required this.CashierMovementId,
    required this.EnterpriseId,
    required this.EnterpriseCode,
    required this.CouponFiscalNumber,
    required this.DiscountType,
    required this.UserIdOfDiscount,
    required this.CRMDiscountType,
    required this.IncrementType,
    required this.SaleFiscalType,
    required this.SalePricePraticed,
    required this.UserIdOfCancellation,
    required this.IsToDelivery,
    required this.DeliveryControl,
    required this.MotiveJustificationId,
    required this.MotiveJustificationSaleDiscountId,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.CustomerAdditionalCode,
    required this.SellerCode,
    required this.DiscountValue,
    required this.DiscountFinalizationValue,
    required this.CRMDiscountValue,
    required this.IncrementValue,
    required this.FidelityControlsPoints,
    required this.TotalLiquid,
    required this.IsCancelled,
    required this.IsForTravel,
    required this.WasPrinted,
    required this.IsDelivery,
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
        Products: data["Products"] != null
            ? (data["Products"] as List)
                .map((e) => SaleMovementProductConcentratorModel.fromJson(e))
                .toList()
            : [],
        Finalizations: data["Finalizations"] != null
            ? (data["Finalizations"] as List)
                .map((e) =>
                    SaleMovementConcentratorFinalizationModel.fromJson(e))
                .toList()
            : [],
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

  SaleMovementConcentratorEntity toEntity() => SaleMovementConcentratorEntity(
        SaleMovementId: SaleMovementId,
        PdvId: PdvId,
        PdvNumber: PdvNumber,
        CashierMovementId: CashierMovementId,
        EnterpriseId: EnterpriseId,
        EnterpriseCode: EnterpriseCode,
        PersonalizedCode: PersonalizedCode,
        CouponFiscalNumber: CouponFiscalNumber,
        DateOfCreation: DateOfCreation,
        DateHourOfCreation: DateHourOfCreation,
        CpfCnpj: CpfCnpj,
        DiscountType: DiscountType,
        DiscountValue: DiscountValue,
        UserIdOfDiscount: UserIdOfDiscount,
        DiscountFinalizationValue: DiscountFinalizationValue,
        CRMDiscountTransactionId: CRMDiscountTransactionId,
        CRMCpfCnpj: CRMCpfCnpj,
        CRMDiscountType: CRMDiscountType,
        CRMDiscountValue: CRMDiscountValue,
        IncrementType: IncrementType,
        IncrementValue: IncrementValue,
        FidelityControlsPoints: FidelityControlsPoints,
        XmlSatNfce: XmlSatNfce,
        XmlSatNfceCancel: XmlSatNfceCancel,
        EletronicAccessKey: EletronicAccessKey,
        SaleRequestPersonalizedCode: SaleRequestPersonalizedCode,
        SaleFiscalType: SaleFiscalType,
        SalePricePraticed: SalePricePraticed,
        SaleFiscalTypeString: SaleFiscalTypeString,
        UserIdOfCancellation: UserIdOfCancellation,
        IsCancelled: IsCancelled,
        IsToDelivery: IsToDelivery,
        IsForTravel: IsForTravel,
        DateHourOfDelivery: DateHourOfDelivery,
        DeliveryControl: DeliveryControl,
        WasPrinted: WasPrinted,
        MotiveJustificationId: MotiveJustificationId,
        MotiveJustificationName: MotiveJustificationName,
        MotiveJustificationSaleDiscountId: MotiveJustificationSaleDiscountId,
        MotiveJustificationSaleDiscountName:
            MotiveJustificationSaleDiscountName,
        IsDelivery: IsDelivery,
        CovenantCode: CovenantCode,
        CustomerCode: CustomerCode,
        CustomerAdditionalCode: CustomerAdditionalCode,
        SellerCode: SellerCode,
        SellerName: SellerName,
        TotalLiquid: TotalLiquid,
        Products: Products.map((e) => e.toEntity()).toList(),
        Finalizations: Finalizations.map((e) => e.toEntity()).toList(),
      );

  factory SaleMovementConcentratorModel.fromEntity(
          SaleMovementConcentratorEntity entity) =>
      SaleMovementConcentratorModel(
        SaleMovementId: entity.SaleMovementId,
        PdvId: entity.PdvId,
        PdvNumber: entity.PdvNumber,
        CashierMovementId: entity.CashierMovementId,
        EnterpriseId: entity.EnterpriseId,
        EnterpriseCode: entity.EnterpriseCode,
        PersonalizedCode: entity.PersonalizedCode,
        CouponFiscalNumber: entity.CouponFiscalNumber,
        DateOfCreation: entity.DateOfCreation,
        DateHourOfCreation: entity.DateHourOfCreation,
        CpfCnpj: entity.CpfCnpj,
        DiscountType: entity.DiscountType,
        DiscountValue: entity.DiscountValue,
        UserIdOfDiscount: entity.UserIdOfDiscount,
        DiscountFinalizationValue: entity.DiscountFinalizationValue,
        CRMDiscountTransactionId: entity.CRMDiscountTransactionId,
        CRMCpfCnpj: entity.CRMCpfCnpj,
        CRMDiscountType: entity.CRMDiscountType,
        CRMDiscountValue: entity.CRMDiscountValue,
        IncrementType: entity.IncrementType,
        IncrementValue: entity.IncrementValue,
        FidelityControlsPoints: entity.FidelityControlsPoints,
        XmlSatNfce: entity.XmlSatNfce,
        XmlSatNfceCancel: entity.XmlSatNfceCancel,
        EletronicAccessKey: entity.EletronicAccessKey,
        SaleRequestPersonalizedCode: entity.SaleRequestPersonalizedCode,
        SaleFiscalType: entity.SaleFiscalType,
        SalePricePraticed: entity.SalePricePraticed,
        SaleFiscalTypeString: entity.SaleFiscalTypeString,
        UserIdOfCancellation: entity.UserIdOfCancellation,
        IsCancelled: entity.IsCancelled,
        IsToDelivery: entity.IsToDelivery,
        IsForTravel: entity.IsForTravel,
        DateHourOfDelivery: entity.DateHourOfDelivery,
        DeliveryControl: entity.DeliveryControl,
        WasPrinted: entity.WasPrinted,
        MotiveJustificationId: entity.MotiveJustificationId,
        MotiveJustificationName: entity.MotiveJustificationName,
        MotiveJustificationSaleDiscountId:
            entity.MotiveJustificationSaleDiscountId,
        MotiveJustificationSaleDiscountName:
            entity.MotiveJustificationSaleDiscountName,
        IsDelivery: entity.IsDelivery,
        CovenantCode: entity.CovenantCode,
        CustomerCode: entity.CustomerCode,
        CustomerAdditionalCode: entity.CustomerAdditionalCode,
        SellerCode: entity.SellerCode,
        SellerName: entity.SellerName,
        TotalLiquid: entity.TotalLiquid,
        Products: entity.Products.map(
            (e) => SaleMovementProductConcentratorModel.fromEntity(e)).toList(),
        Finalizations: entity.Finalizations.map(
                (e) => SaleMovementConcentratorFinalizationModel.fromEntity(e))
            .toList(),
      );
}
