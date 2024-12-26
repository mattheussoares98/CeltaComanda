// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class SaleMovementConcentratorFinalizationModel extends Equatable {
  final int? SaleMovementFinalizationId;
  final int? FinalizationId;
  final double? Value;
  final double? PayBackValue;
  final double? ValueLiquid;
  final String? AuthorizationCode;
  final int? AuthorizationType;
  final int? PortionQuantity;
  final int? FinalizationPdvId;
  final String? TEFNSUSitef;
  final String? TEFNSUHost;
  final String? TEFAuthorizationCode;
  final String? TEFBinCode;
  final String? TEFCardLastNumbers;
  final String? TEFNetWorkCode;
  final String? TEFFlagCode;
  final String? TEFFlagDescription;
  final String? TEFModalityPaymentCode;
  final String? TEFModalityDescription;
  final String? TEFPlanCardCode;
//  public virtual ModelSaleMovement SaleMovement
//  public virtual IList<ModelSaleMovementFinalizationCheck> Checks
//  public virtual IList<ModelSaleMovementFinalizationPortion> Portions

  const SaleMovementConcentratorFinalizationModel({
    required this.SaleMovementFinalizationId,
    required this.FinalizationId,
    required this.Value,
    required this.PayBackValue,
    required this.ValueLiquid,
    required this.AuthorizationCode,
    required this.AuthorizationType,
    required this.PortionQuantity,
    required this.FinalizationPdvId,
    required this.TEFNSUSitef,
    required this.TEFNSUHost,
    required this.TEFAuthorizationCode,
    required this.TEFBinCode,
    required this.TEFCardLastNumbers,
    required this.TEFNetWorkCode,
    required this.TEFFlagCode,
    required this.TEFFlagDescription,
    required this.TEFModalityPaymentCode,
    required this.TEFModalityDescription,
    required this.TEFPlanCardCode,
  });

  @override
  List<Object?> get props => [
        SaleMovementFinalizationId,
        FinalizationId,
        Value,
        PayBackValue,
        ValueLiquid,
        AuthorizationCode,
        AuthorizationType,
        PortionQuantity,
        FinalizationPdvId,
        TEFNSUSitef,
        TEFNSUHost,
        TEFAuthorizationCode,
        TEFBinCode,
        TEFCardLastNumbers,
        TEFNetWorkCode,
        TEFFlagCode,
        TEFFlagDescription,
        TEFModalityPaymentCode,
        TEFModalityDescription,
        TEFPlanCardCode,
      ];

  factory SaleMovementConcentratorFinalizationModel.fromJson(Map data) =>
      SaleMovementConcentratorFinalizationModel(
        SaleMovementFinalizationId: data["SaleMovementFinalizationId"],
        FinalizationId: data["FinalizationId"],
        Value: data["Value"],
        PayBackValue: data["PayBackValue"],
        ValueLiquid: data["ValueLiquid"],
        AuthorizationCode: data["AuthorizationCode"],
        AuthorizationType: data["AuthorizationType"],
        PortionQuantity: data["PortionQuantity"],
        FinalizationPdvId: data["FinalizationPdvId"],
        TEFNSUSitef: data["TEFNSUSitef"],
        TEFNSUHost: data["TEFNSUHost"],
        TEFAuthorizationCode: data["TEFAuthorizationCode"],
        TEFBinCode: data["TEFBinCode"],
        TEFCardLastNumbers: data["TEFCardLastNumbers"],
        TEFNetWorkCode: data["TEFNetWorkCode"],
        TEFFlagCode: data["TEFFlagCode"],
        TEFFlagDescription: data["TEFFlagDescription"],
        TEFModalityPaymentCode: data["TEFModalityPaymentCode"],
        TEFModalityDescription: data["TEFModalityDescription"],
        TEFPlanCardCode: data["TEFPlanCardCode"],
      );

  Map<String, dynamic> toJson() => {
        "SaleMovementFinalizationId": SaleMovementFinalizationId,
        "FinalizationId": FinalizationId,
        "Value": Value,
        "PayBackValue": PayBackValue,
        "ValueLiquid": ValueLiquid,
        "AuthorizationCode": AuthorizationCode,
        "AuthorizationType": AuthorizationType,
        "PortionQuantity": PortionQuantity,
        "FinalizationPdvId": FinalizationPdvId,
        "TEFNSUSitef": TEFNSUSitef,
        "TEFNSUHost": TEFNSUHost,
        "TEFAuthorizationCode": TEFAuthorizationCode,
        "TEFBinCode": TEFBinCode,
        "TEFCardLastNumbers": TEFCardLastNumbers,
        "TEFNetWorkCode": TEFNetWorkCode,
        "TEFFlagCode": TEFFlagCode,
        "TEFFlagDescription": TEFFlagDescription,
        "TEFModalityPaymentCode": TEFModalityPaymentCode,
        "TEFModalityDescription": TEFModalityDescription,
        "TEFPlanCardCode": TEFPlanCardCode,
      };

  SaleMovementConcentratorFinalizationEntity toEntity() =>
      SaleMovementConcentratorFinalizationEntity(
        SaleMovementFinalizationId: SaleMovementFinalizationId,
        FinalizationId: FinalizationId,
        Value: Value,
        PayBackValue: PayBackValue,
        ValueLiquid: ValueLiquid,
        AuthorizationCode: AuthorizationCode,
        AuthorizationType: AuthorizationType,
        PortionQuantity: PortionQuantity,
        FinalizationPdvId: FinalizationPdvId,
        TEFNSUSitef: TEFNSUSitef,
        TEFNSUHost: TEFNSUHost,
        TEFAuthorizationCode: TEFAuthorizationCode,
        TEFBinCode: TEFBinCode,
        TEFCardLastNumbers: TEFCardLastNumbers,
        TEFNetWorkCode: TEFNetWorkCode,
        TEFFlagCode: TEFFlagCode,
        TEFFlagDescription: TEFFlagDescription,
        TEFModalityPaymentCode: TEFModalityPaymentCode,
        TEFModalityDescription: TEFModalityDescription,
        TEFPlanCardCode: TEFPlanCardCode,
      );
}
