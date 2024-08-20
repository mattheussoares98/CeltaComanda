// ignore_for_file: non_constant_identifier_names

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';

class UpdateSaleRequestTempModel {
  final String? Comments;
  final int DeliveryControl;
  final int EnterpriseId;
  final String PersonalizedCode;
  final int SaleRequestTempId;
  final int? Peoples;
  final double TotalLiquid;
  final List<UpdateSaleRequestTempProductEntity> Products;

  UpdateSaleRequestTempModel({
    required this.DeliveryControl,
    required this.EnterpriseId,
    required this.PersonalizedCode,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Products,
    required this.Comments,
    required this.Peoples,
  });

  factory UpdateSaleRequestTempModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(
      [
        "DeliveryControl",
        "EnterpriseId",
        "PersonalizedCode",
        "SaleRequestTempId",
        "TotalLiquid",
        "Products",
      ],
    )) {
      throw Exception();
    }

    return UpdateSaleRequestTempModel(
      DeliveryControl: json["DeliveryControl"],
      EnterpriseId: json["EnterpriseId"],
      PersonalizedCode: json["PersonalizedCode"],
      SaleRequestTempId: json["SaleRequestTempId"],
      TotalLiquid: json["TotalLiquid"],
      Products: json["Products"],
      Comments: json["Comments"],
      Peoples: json["Peoples"],
    );
  }

  factory UpdateSaleRequestTempModel.fromEntity(
          UpdateSaleRequestTempEntity entity) =>
      UpdateSaleRequestTempModel(
        DeliveryControl: entity.DeliveryControl,
        EnterpriseId: entity.EnterpriseId,
        PersonalizedCode: entity.PersonalizedCode,
        SaleRequestTempId: entity.SaleRequestTempId,
        TotalLiquid: entity.TotalLiquid,
        Products: entity.Products,
        Comments: entity.Comments,
        Peoples: entity.Peoples,
      );

  UpdateSaleRequestTempEntity toEntity() => UpdateSaleRequestTempEntity(
        DeliveryControl: DeliveryControl,
        EnterpriseId: EnterpriseId,
        PersonalizedCode: PersonalizedCode,
        SaleRequestTempId: SaleRequestTempId,
        TotalLiquid: TotalLiquid,
        Products: Products,
        Comments: Comments,
        Peoples: Peoples,
      );

  Map<dynamic, dynamic> toJson() => {
        "DeliveryControl": DeliveryControl,
        "EnterpriseId": EnterpriseId,
        "PersonalizedCode": PersonalizedCode,
        "SaleRequestTempId": SaleRequestTempId,
        "TotalLiquid": TotalLiquid,
        "Products": Products.map((e) =>
            UpdateSaleRequestTempProductsModel.fromEntity(e).toJson()).toList(),
        "Comments": Comments,
        "Peoples": Peoples,
      };
}
