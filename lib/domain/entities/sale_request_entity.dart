import 'entities.dart';

class SaleRequestEntity {
  final List<SaleRequestProductEntity> Products;
  final String DateOfCreation;
  final String DateHourOfCreation;
  final String RequestType;
  final int? SellerCode;
  final String FlagStatus;
  final String Comments;
  final String PersonalizedCode;
  final String? PlaceId;
  final bool IsCancelled;
  final bool IsUsing;
  final double TotalLiquid;
  final int? CovenantCode;
  final int? CustomerCode;
  final int EnterpriseId;
  final int Peoples;
  final int FlagOrigin;
  final int DeliveryControl;
  final int SaleRequestId;
  final double? IncrementValue;
  final int? IncrementType; //1 == value && 2 == percentage

  SaleRequestEntity({
    required this.Products,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.RequestType,
    required this.SellerCode,
    required this.FlagStatus,
    required this.Comments,
    required this.PersonalizedCode,
    required this.PlaceId,
    required this.IsCancelled,
    required this.IsUsing,
    required this.TotalLiquid,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.EnterpriseId,
    required this.Peoples,
    required this.FlagOrigin,
    required this.DeliveryControl,
    required this.SaleRequestId,
    required this.IncrementValue,
    required this.IncrementType,
  });
}
