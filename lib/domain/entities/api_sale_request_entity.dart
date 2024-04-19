class ApiSaleRequestEntity {
  final dynamic products;
  final int saleRequestTempId;
  final String personalizedCode;
  final int enterpriseId;
  final double totalLiquid;
  final int deliveryControl;
  final String? comments;

  const ApiSaleRequestEntity({
    required this.products,
    required this.saleRequestTempId,
    required this.personalizedCode,
    required this.enterpriseId,
    required this.totalLiquid,
    required this.deliveryControl,
    this.comments,
  });
}
