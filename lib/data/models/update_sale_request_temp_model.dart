import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';

class UpdateSaleRequestTempModel {
  final String? Comments;
  final int? DeliveryControl;
  final int EnterpriseId;
  final String PersonalizedCode;
  final int SaleRequestTempId;
  final int? Peoples;
  final String? SellerCode;
  final double TotalLiquid;
  final List<UpdateSaleRequestTempProductEntity> Products;
  final int? CustomerCode;
  final int? CovenantCode;
  final int? IsToDelivery;
  final double? IncrementValue;
  final int? IncrementType; //1 == value && 2 == percentage
  final String? PlaceId;

  UpdateSaleRequestTempModel({
    required this.DeliveryControl,
    required this.EnterpriseId,
    required this.PersonalizedCode,
    required this.SaleRequestTempId,
    required this.TotalLiquid,
    required this.Products,
    required this.Comments,
    required this.Peoples,
    required this.SellerCode,
    required this.CustomerCode,
    required this.CovenantCode,
    required this.IsToDelivery,
    required this.IncrementValue,
    required this.IncrementType,
    required this.PlaceId,
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
      SellerCode: json["SellerCode"],
      CovenantCode: json["CovenantCode"],
      IsToDelivery: json["IsToDelivery"],
      CustomerCode: json["CustomerCode"],
      IncrementValue: json["IncrementValue"],
      IncrementType: json["IncrementType"],
      PlaceId: json["PlaceId"],
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
        SellerCode: entity.SellerCode,
        CustomerCode: entity.CustomerCode,
        CovenantCode: entity.CovenantCode,
        IsToDelivery: entity.IsToDelivery,
        IncrementValue: entity.IncrementValue,
        IncrementType: entity.IncrementType,
        PlaceId: entity.PlaceId,
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
        SellerCode: SellerCode,
        CustomerCode: CustomerCode,
        CovenantCode: CovenantCode,
        IsToDelivery: IsToDelivery,
        IncrementValue: IncrementValue,
        IncrementType: IncrementType,
        PlaceId: PlaceId,
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
        "SellerCode": SellerCode,
        "CustomerCode": CustomerCode,
        "CovenantCode": CovenantCode,
        "IsToDelivery": IsToDelivery,
        "IncrementValue": IncrementValue,
        "IncrementType": IncrementType,
        "PlaceId": PlaceId,
      };
}
