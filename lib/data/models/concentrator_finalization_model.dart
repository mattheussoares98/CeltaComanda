

import 'package:equatable/equatable.dart';

class ConcentratorFinalizationModel extends Equatable {
//  final ModelSaleMovement SaleMovement ;
//  final IList<ModelSaleMovementFinalizationCheck> Checks ;
//  final IList<ModelSaleMovementFinalizationPortion> Portions ;

  final int? AuthorizationType;
  final int FinalizationId;
  final int PortionQuantity;
  final double Value;
  final double ValueLiquid;

  final int? SaleMovementFinalizationId;
  final double? PayBackValue;
  final String? AuthorizationCode;
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
  final String? finalizationIdentification;

  const ConcentratorFinalizationModel({
    required this.FinalizationId,
    required this.Value,
    required this.ValueLiquid,
    required this.PortionQuantity,
    this.finalizationIdentification,
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
  });

  @override
  List<Object?> get props => [
        FinalizationId,
        finalizationIdentification,
        AuthorizationType,
        Value,
        ValueLiquid,
        PortionQuantity,
        SaleMovementFinalizationId,
        PayBackValue,
        AuthorizationCode,
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

  Map<String, dynamic> toJson() => {
        "FinalizationId": FinalizationId,
        "AuthorizationType": AuthorizationType,
        "Value": Value,
        "ValueLiquid": ValueLiquid,
        "PortionQuantity": PortionQuantity,
        "SaleMovementFinalizationId": SaleMovementFinalizationId,
        "PayBackValue": PayBackValue,
        "AuthorizationCode": AuthorizationCode,
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
}

enum FinalizationIdentification {
  money,
  check,
  pix,
  purchaseVale,
  debitCard,
  creditCard,
  covenant,
  pos,
  portion,
  financialCredits,
}

extension FinalizationIdentificationExtension on FinalizationIdentification {
  int get finalizationId {
    switch (this) {
      case FinalizationIdentification.money:
        return 1;
      case FinalizationIdentification.check:
        return 2;
      case FinalizationIdentification.pix:
        return 3;
      case FinalizationIdentification.purchaseVale:
        return 4;
      case FinalizationIdentification.debitCard:
        return 5;
      case FinalizationIdentification.creditCard:
        return 6;
      case FinalizationIdentification.covenant:
        return 7;
      case FinalizationIdentification.pos:
        return 8;
      case FinalizationIdentification.portion:
        return 9;
      case FinalizationIdentification.financialCredits:
        return 10;
    }
  }
}
