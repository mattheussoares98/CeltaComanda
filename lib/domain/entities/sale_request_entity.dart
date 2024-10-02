// ignore_for_file: non_constant_identifier_names

import 'entities.dart';

class SaleRequestEntity {
  final List<ProductEntity> Products;
  final String DateOfCreation;
  final String DateHourOfCreation;
  final String RequestType;
  final String SellerCode;
  final String FlagStatus;
  final String Comments;
  final bool IsCancelled;
  final bool IsUsing;
  final double TotalLiquid;
  final int? CovenantCode;
  final int? CustomerCode;
  final int EnterpriseId;
  final int Peoples;
  final int FlagOrigin;
  final int DeliveryControl;

  SaleRequestEntity({
    required this.Products,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.RequestType,
    required this.SellerCode,
    required this.FlagStatus,
    required this.Comments,
    required this.IsCancelled,
    required this.IsUsing,
    required this.TotalLiquid,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.EnterpriseId,
    required this.Peoples,
    required this.FlagOrigin,
    required this.DeliveryControl,
  });
}
