// ignore_for_file: non_constant_identifier_names

import 'entities.dart';

class UpdateSaleRequestTempEntity {
  final String? Comments;
  final int DeliveryControl;
  final int EnterpriseId;
  final String PersonalizedCode;
  final int SaleRequestTempId;
  final double TotalLiquid;
  final List<UpdateSaleRequestTempProductEntity> Products;

  UpdateSaleRequestTempEntity({
    this.Comments,
    required this.DeliveryControl,
    required this.EnterpriseId,
    required this.PersonalizedCode,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Products,
  });
}
