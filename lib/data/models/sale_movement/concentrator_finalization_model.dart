import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../../ui/helpers/helpers.dart';

class ConcentratorFinalizationModel extends Equatable {
  final int? SaleMovementFinalizationId;
  final int? FinalizationId;
  final FinalizationType? finalizationType;
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
  final String uniqueId;

  ConcentratorFinalizationModel({
    required this.FinalizationId,
    required this.Value,
    required this.ValueLiquid,
    required this.PortionQuantity,
    this.finalizationType,
    this.AuthorizationType,
    this.SaleMovementFinalizationId,
    this.PayBackValue,
    this.AuthorizationCode,
    this.FinalizationPdvId,
    this.TEFNSUSitef,
    this.TEFNSUHost,
    this.TEFAuthorizationCode,
    this.TEFBinCode,
    this.TEFCardLastNumbers,
    this.TEFNetWorkCode,
    this.TEFFlagCode,
    this.TEFFlagDescription,
    this.TEFModalityPaymentCode,
    this.TEFModalityDescription,
    this.TEFPlanCardCode,
    String? uniqueId,
  }) : uniqueId = uniqueId ?? DateTime.now().millisecondsSinceEpoch.toString();

  @override
  List<Object?> get props => [
        uniqueId,
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

  factory ConcentratorFinalizationModel.fromJson(Map data) =>
      ConcentratorFinalizationModel(
        SaleMovementFinalizationId: data["SaleMovementFinalizationId"],
        FinalizationId: data["FinalizationId"],
        finalizationType: (data["FinalizationId"] as int).finalizationId,
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

  ConcentratorFinalizationEntity toEntity() => ConcentratorFinalizationEntity(
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

  factory ConcentratorFinalizationModel.fromEntity(
          ConcentratorFinalizationEntity entity) =>
      ConcentratorFinalizationModel(
        SaleMovementFinalizationId: entity.SaleMovementFinalizationId,
        FinalizationId: entity.FinalizationId,
        finalizationType: entity.FinalizationId!.finalizationId,
        Value: entity.Value,
        PayBackValue: entity.PayBackValue,
        ValueLiquid: entity.ValueLiquid,
        AuthorizationCode: entity.AuthorizationCode,
        AuthorizationType: entity.AuthorizationType,
        PortionQuantity: entity.PortionQuantity,
        FinalizationPdvId: entity.FinalizationPdvId,
        TEFNSUSitef: entity.TEFNSUSitef,
        TEFNSUHost: entity.TEFNSUHost,
        TEFAuthorizationCode: entity.TEFAuthorizationCode,
        TEFBinCode: entity.TEFBinCode,
        TEFCardLastNumbers: entity.TEFCardLastNumbers,
        TEFNetWorkCode: entity.TEFNetWorkCode,
        TEFFlagCode: entity.TEFFlagCode,
        TEFFlagDescription: entity.TEFFlagDescription,
        TEFModalityPaymentCode: entity.TEFModalityPaymentCode,
        TEFModalityDescription: entity.TEFModalityDescription,
        TEFPlanCardCode: entity.TEFPlanCardCode,
      );
}

enum FinalizationType {
  money, // == 1
  check, // == 2
  pix, // == 3
  purchaseVale, // == 4
  debitCard, // == 5
  creditCard, // == 6
  covenant, // == 7
  pos, // == 8
  portion, // == 9
  financialCredits, // == 10
}

extension FinalizationTypeExtensionInt on int {
  FinalizationType get finalizationId {
    switch (this) {
      case 1:
        return FinalizationType.money;
      case 2:
        return FinalizationType.check;
      case 3:
        return FinalizationType.pix;
      case 4:
        return FinalizationType.purchaseVale;
      case 5:
        return FinalizationType.debitCard;
      case 6:
        return FinalizationType.creditCard;
      case 7:
        return FinalizationType.covenant;
      case 8:
        return FinalizationType.pos;
      case 9:
        return FinalizationType.portion;
      case 10:
        return FinalizationType.financialCredits;
      default:
        return FinalizationType.money;
    }
  }
}

extension FinalizationTypeExtensionName on FinalizationType {
  String get name {
    switch (this) {
      case FinalizationType.money:
        return R.string.money;
      case FinalizationType.check:
        return R.string.check;
      case FinalizationType.pix:
        return R.string.pix;
      case FinalizationType.purchaseVale:
        return R.string.purchaseVale;
      case FinalizationType.debitCard:
        return R.string.debit;
      case FinalizationType.creditCard:
        return R.string.credit;
      case FinalizationType.covenant:
        return R.string.covenant;
      case FinalizationType.pos:
        return R.string.pos;
      case FinalizationType.portion: //boleto
        return R.string.portion; //boleto
      case FinalizationType.financialCredits:
        return R.string.financialCredits;
    }
  }
}

extension FinalizationTypeExtension on FinalizationType {
  int get id {
    switch (this) {
      case FinalizationType.money:
        return 1;
      case FinalizationType.check:
        return 2;
      case FinalizationType.pix:
        return 3;
      case FinalizationType.purchaseVale:
        return 4;
      case FinalizationType.debitCard:
        return 5;
      case FinalizationType.creditCard:
        return 6;
      case FinalizationType.covenant:
        return 7;
      case FinalizationType.pos:
        return 8;
      case FinalizationType.portion:
        return 9;
      case FinalizationType.financialCredits:
        return 10;
    }
  }
}
