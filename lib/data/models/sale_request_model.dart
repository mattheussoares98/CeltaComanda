// ignore_for_file: non_constant_identifier_names

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';

class SaleRequestModel {
  final List<SaleRequestTempProductEntity> Products;
  final int SaleRequestTempId;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int? DeliveryControl;
  final int? Peoples;
  final String? Comments;
  final String? SellerCode;
  final int? CustomerCode;
  final int? CovenantCode;

  SaleRequestModel({
    required this.Products,
    required this.SaleRequestTempId,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    required this.Peoples,
    required this.Comments,
    required this.SellerCode,
    required this.CustomerCode,
    required this.CovenantCode,
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
      Peoples: json["Peoples"],
      SellerCode: json["SellerCode"],
      CustomerCode: json["CustomerCode"],
      CovenantCode: json["CovenantCode"],
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
        Peoples: entity.Peoples,
        SellerCode: entity.SellerCode,
        CustomerCode: entity.CustomerCode,
        CovenantCode: entity.CovenantCode,
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
        CustomerCode: CustomerCode,
        CovenantCode: CovenantCode,
      );

  Map<String, dynamic> toJson() => {
        "Products": Products,
        "SaleRequestTempId": SaleRequestTempId,
        "PersonalizedCode": PersonalizedCode,
        "EnterpriseId": EnterpriseId,
        "TotalLiquid": TotalLiquid,
        "DeliveryControl": DeliveryControl,
        "Comments": Comments,
        "Peoples": Peoples,
        "SellerCode": SellerCode,
        "CustomerCode": CustomerCode,
        "CovenantCode": CovenantCode,
      };
}
