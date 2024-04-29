// ignore_for_file: non_constant_identifier_names

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';

class SaleRequestModel {
  final List<SaleRequestTempProductEntity> Products;
  final int SaleRequestTempId;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int DeliveryControl;
  final String? Comments;

  SaleRequestModel({
    required this.Products,
    required this.SaleRequestTempId,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
  });

  factory SaleRequestModel.fromJson(Map json) {
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
    return SaleRequestModel(
      Products: json["Products"]
          .map<SaleRequestTempProductEntity>(
              (e) => SaleRequestTempProductsModel.fromJson(e).toEntity())
          .toList(),
      SaleRequestTempId: json["SaleRequestTempId"],
      PersonalizedCode: json["PersonalizedCode"],
      EnterpriseId: json["EnterpriseId"],
      TotalLiquid: json["TotalLiquid"],
      DeliveryControl: json["DeliveryControl"],
      Comments: json["Comments"],
    );
  }

  factory SaleRequestModel.fromEntity(SaleRequestTempEntity entity) =>
      SaleRequestModel(
        Products: entity.Products,
        SaleRequestTempId: entity.SaleRequestTempId,
        PersonalizedCode: entity.PersonalizedCode,
        EnterpriseId: entity.EnterpriseId,
        TotalLiquid: entity.TotalLiquid,
        DeliveryControl: entity.DeliveryControl,
        Comments: entity.Comments,
      );

  SaleRequestTempEntity toEntity() => SaleRequestTempEntity(
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
