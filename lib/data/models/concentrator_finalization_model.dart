// ignore_for_file: non_constant_identifier_names

class ConcentratorFinalizationModel {
//  final ModelSaleMovement SaleMovement ;
//  final FinancialAuthorizationType? AuthorizationType ;
//  final IList<ModelSaleMovementFinalizationCheck> Checks ;
//  final IList<ModelSaleMovementFinalizationPortion> Portions ;

  final FinalizationIdentification FinalizationId;
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

  const ConcentratorFinalizationModel({
    required this.FinalizationId,
    required this.Value,
    required this.ValueLiquid,
    required this.PortionQuantity,
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
  int get description {
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
      default:
        return 1;
    }
  }
}
