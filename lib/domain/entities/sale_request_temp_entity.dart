// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class SaleRequestTempEntity {
  final List<ProductEntity> Products;
  final int SaleRequestTempId;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int DeliveryControl;
  final String? Comments;

  const SaleRequestTempEntity({
    required this.Products,
    required this.SaleRequestTempId,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
  });
}
