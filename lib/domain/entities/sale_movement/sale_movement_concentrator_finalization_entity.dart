

import 'package:equatable/equatable.dart';

class SaleMovementConcentratorFinalizationEntity extends Equatable {
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

  const SaleMovementConcentratorFinalizationEntity({
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
}
