// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class PrintedEntity {
  final List<PrintedProductsEntity> Products;
  final String PersonalizedCode;
  final String DateOfCreation;
  final String DateHourOfCreation;
  final String FlagStatus;
  final int EnterpriseId;
  final dynamic RequestType;
  final bool IsCancelled;
  final bool IsUsing;
  final double TotalLiquid;
  final int Peoples;
  final int SaleRequestId;
  final int FlagOrigin;
  final int DeliveryControl;
  final int? IncrementType;
  final double? IncrementValue;
  String? Comments;

  PrintedEntity({
    required this.Products,
    required this.PersonalizedCode,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.FlagStatus,
    this.Comments,
    required this.EnterpriseId,
    required this.RequestType,
    required this.IsCancelled,
    required this.IsUsing,
    required this.TotalLiquid,
    required this.Peoples,
    required this.SaleRequestId,
    required this.FlagOrigin,
    required this.DeliveryControl,
    required this.IncrementType,
    required this.IncrementValue,
  });
}
