// ignore_for_file: non_constant_identifier_names

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';

class SaleRequestTempModel {
  final List<SaleRequestTempProductEntity> Products;
  final int SaleRequestTempId;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int? DeliveryControl;
  final int? Peoples;
  final String? Comments;
  final String? SellerCode;

  SaleRequestTempModel({
    required this.Products,
    required this.SaleRequestTempId,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    required this.Comments,
    required this.Peoples,
    required this.SellerCode,
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
      Peoples: json["Peoples"],
      SellerCode: json["SellerCode"],
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
        Peoples: entity.Peoples,
        SellerCode: entity.SellerCode,
      );

  SaleRequestTempEntity toEntity() => SaleRequestTempEntity(
        Products: Products,
        SaleRequestTempId: SaleRequestTempId,
        PersonalizedCode: PersonalizedCode,
        EnterpriseId: EnterpriseId,
        TotalLiquid: TotalLiquid,
        DeliveryControl: DeliveryControl,
        Comments: Comments,
        Peoples: Peoples,
        SellerCode: SellerCode,
      );
  Map<String, dynamic> toJson() => {
        "Products": Products.map(
                (e) => SaleRequestTempProductsModel.fromEntity(e).toJson())
            .toList(),
        "SaleRequestTempId": SaleRequestTempId,
        "PersonalizedCode": PersonalizedCode,
        "EnterpriseId": EnterpriseId,
        "TotalLiquid": TotalLiquid,
        "DeliveryControl": DeliveryControl,
        "Comments": Comments,
        "Peoples": Peoples,
        "SellerCode": SellerCode,
      };
}
