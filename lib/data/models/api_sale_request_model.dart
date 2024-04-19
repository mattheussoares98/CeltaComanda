import '../../domain/entities/entities.dart';

class ApiSaleRequestModel {
  final dynamic products;
  final int saleRequestTempId;
  final String personalizedCode;
  final int enterpriseId;
  final double totalLiquid;
  final int deliveryControl;
  final String? comments;

  ApiSaleRequestModel({
    required this.products,
    required this.saleRequestTempId,
    required this.personalizedCode,
    required this.enterpriseId,
    required this.totalLiquid,
    required this.deliveryControl,
    this.comments,
  });

  factory ApiSaleRequestModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      "products",
      "saleRequestTempId",
      "personalizedCode",
      "enterpriseId",
      "totalLiquid",
      "deliveryControl",
    ])) {
      throw Exception();
    }
    return ApiSaleRequestModel(
      products: json["products"],
      saleRequestTempId: json["saleRequestTempId"],
      personalizedCode: json["personalizedCode"],
      enterpriseId: json["enterpriseId"],
      totalLiquid: json["totalLiquid"],
      deliveryControl: json["deliveryControl"],
      comments: json["comments"],
    );
  }

  factory ApiSaleRequestModel.fromEntity(ApiSaleRequestEntity entity) =>
      ApiSaleRequestModel(
        products: entity.products,
        saleRequestTempId: entity.saleRequestTempId,
        personalizedCode: entity.personalizedCode,
        enterpriseId: entity.enterpriseId,
        totalLiquid: entity.totalLiquid,
        deliveryControl: entity.deliveryControl,
        comments: entity.comments,
      );

  ApiSaleRequestEntity toEntity() => ApiSaleRequestEntity(
        products: products,
        saleRequestTempId: saleRequestTempId,
        personalizedCode: personalizedCode,
        enterpriseId: enterpriseId,
        totalLiquid: totalLiquid,
        deliveryControl: deliveryControl,
        comments: comments,
      );

  Map<String, dynamic> toJson() => {
        "products": products,
        "saleRequestTempId": saleRequestTempId,
        "personalizedCode": personalizedCode,
        "enterpriseId": enterpriseId,
        "totalLiquid": totalLiquid,
        "deliveryControl": deliveryControl,
        "comments": comments,
      };
}
