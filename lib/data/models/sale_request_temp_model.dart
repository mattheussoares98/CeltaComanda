// ignore_for_file: non_constant_identifier_names

import 'package:clean_celta_mobile/data/models/models.dart';

import '../../domain/entities/entities.dart';

class SaleRequestTempModel {
  final List<SaleRequestTempProductEntity> Products;
  final int SaleRequestTempId;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int DeliveryControl;
  final String? Comments;

  SaleRequestTempModel({
    required this.Products,
    required this.SaleRequestTempId,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
  });

  factory SaleRequestTempModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(
      [
        "Products",
        "SaleRequestTempId",
        "PersonalizedCode",
        "EnterpriseId",
        "TotalLiquid",
        "DeliveryControl",
      ],
    )) {
      throw Exception();
    }

    return SaleRequestTempModel(
      Products: json["Products"]
          .map((e) => SaleRequestTempProductsModel.fromJson(e).toEntity())
          .toList(),
      SaleRequestTempId: json["SaleRequestTempId"],
      PersonalizedCode: json["PersonalizedCode"],
      EnterpriseId: json["EnterpriseId"],
      TotalLiquid: json["TotalLiquid"],
      DeliveryControl: json["DeliveryControl"],
      Comments: json["Comments"],
    );
  }

  factory SaleRequestTempModel.fromEntity(SaleRequestTempEntity entity) =>
      SaleRequestTempModel(
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
