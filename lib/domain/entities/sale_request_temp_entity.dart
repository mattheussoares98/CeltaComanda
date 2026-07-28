import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class SaleRequestTempEntity extends Equatable {
  final List<SaleRequestTempProductEntity> Products;
  final int SaleRequestTempId;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int? DeliveryControl;
  final int? Peoples;
  final String? Comments;
  final String? SellerCode;
  final int? CustomerCode;
  final int? CovenantCode;
  final int? IsToDelivery;
  final double? IncrementValue;
  final int? IncrementType; //1 == value && 2 == percentage
  final String? PlaceId; //1 == value && 2 == percentage

  const SaleRequestTempEntity({
    required this.Products,
    required this.SaleRequestTempId,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    required this.Comments,
    required this.Peoples,
    required this.SellerCode,
    required this.CustomerCode,
    required this.CovenantCode,
    required this.IsToDelivery,
    required this.IncrementValue,
    required this.IncrementType,
    required this.PlaceId,
  });

  @override
  List<Object?> get props => [
        Products,
        SaleRequestTempId,
        PersonalizedCode,
        EnterpriseId,
        TotalLiquid,
        DeliveryControl,
        Comments,
        Peoples,
        SellerCode,
        CustomerCode,
        CovenantCode,
        IsToDelivery,
        IncrementValue,
        IncrementType,
        PlaceId,
      ];
}
