// ignore_for_file: non_constant_identifier_names

import '../../domain/entities/entities.dart';

class ApiSaleRequestModel {
  final dynamic Products;
  final int SaleRequestTempId;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int DeliveryControl;
  final String? Comments;

  ApiSaleRequestModel({
    required this.Products,
    required this.SaleRequestTempId,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
  });

  factory ApiSaleRequestModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      "Products",
      "SaleRequestTempId",
      "PersonalizedCode",
      "EnterpriseId",
      "TotalLiquid",
      "DeliveryControl",
    ])) {
      throw Exception();
    }
    return ApiSaleRequestModel(
      Products: json["Products"],
      SaleRequestTempId: json["SaleRequestTempId"],
      PersonalizedCode: json["PersonalizedCode"],
      EnterpriseId: json["EnterpriseId"],
      TotalLiquid: json["TotalLiquid"],
      DeliveryControl: json["DeliveryControl"],
      Comments: json["Comments"],
    );
  }

  factory ApiSaleRequestModel.fromEntity(SaleRequestEntity entity) =>
      ApiSaleRequestModel(
        Products: entity.Products,
        SaleRequestTempId: entity.SaleRequestTempId,
        PersonalizedCode: entity.PersonalizedCode,
        EnterpriseId: entity.EnterpriseId,
        TotalLiquid: entity.TotalLiquid,
        DeliveryControl: entity.DeliveryControl,
        Comments: entity.Comments,
      );

  SaleRequestEntity toEntity() => SaleRequestEntity(
        Products: Products,
        SaleRequestTempId: SaleRequestTempId,
        PersonalizedCode: PersonalizedCode,
        EnterpriseId: EnterpriseId,
        TotalLiquid: TotalLiquid,
        DeliveryControl: DeliveryControl,
        Comments: Comments,
      );

  Map<String, dynamic> toJson() => {
        "Products": Products,
        "SaleRequestTempId": SaleRequestTempId,
        "PersonalizedCode": PersonalizedCode,
        "EnterpriseId": EnterpriseId,
        "TotalLiquid": TotalLiquid,
        "DeliveryControl": DeliveryControl,
        "Comments": Comments,
      };
}
