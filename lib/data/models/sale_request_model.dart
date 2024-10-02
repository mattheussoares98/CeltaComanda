// ignore_for_file: non_constant_identifier_names

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';

class SaleRequestModel {
  final List<ProductModel> Products;
  final String DateOfCreation;
  final String DateHourOfCreation;
  final String RequestType;
  final String SellerCode;
  final String FlagStatus;
  final String Comments;
  final String PersonalizedCode;
  final bool IsCancelled;
  final bool IsUsing;
  final double TotalLiquid;
  final int? CovenantCode;
  final int? CustomerCode;
  final int EnterpriseId;
  final int Peoples;
  final int FlagOrigin;
  final int DeliveryControl;
  final int SaleRequestId;

  SaleRequestModel({
    required this.Products,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.RequestType,
    required this.SellerCode,
    required this.FlagStatus,
    required this.Comments,
    required this.PersonalizedCode,
    required this.IsCancelled,
    required this.IsUsing,
    required this.TotalLiquid,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.EnterpriseId,
    required this.Peoples,
    required this.FlagOrigin,
    required this.DeliveryControl,
    required this.SaleRequestId,
  });

  factory SaleRequestModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      "SaleRequestId",
      "PersonalizedCode",
    ])) {
      throw Exception();
    }
    return SaleRequestModel(
      Products: json["Products"]
          .map<SaleRequestTempProductEntity>(
              (e) => SaleRequestTempProductsModel.fromJson(e).toEntity())
          .toList(),
      DateOfCreation: json["DateOfCreation"],
      DateHourOfCreation: json["DateHourOfCreation"],
      RequestType: json["RequestType"],
      SellerCode: json["SellerCode"],
      FlagStatus: json["FlagStatus"],
      Comments: json["Comments"],
      PersonalizedCode: json["PersonalizedCode"],
      IsCancelled: json["IsCancelled"],
      IsUsing: json["IsUsing"],
      TotalLiquid: json["TotalLiquid"],
      CovenantCode: json["CovenantCode"],
      CustomerCode: json["CustomerCode"],
      EnterpriseId: json["EnterpriseId"],
      Peoples: json["Peoples"],
      FlagOrigin: json["FlagOrigin"],
      DeliveryControl: json["DeliveryControl"],
      SaleRequestId: json["SaleRequestId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Products": Products,
        "DateOfCreation": DateOfCreation,
        "DateHourOfCreation": DateHourOfCreation,
        "RequestType": RequestType,
        "SellerCode": SellerCode,
        "FlagStatus": FlagStatus,
        "Comments": Comments,
        "PersonalizedCode": PersonalizedCode,
        "IsCancelled": IsCancelled,
        "IsUsing": IsUsing,
        "TotalLiquid": TotalLiquid,
        "CovenantCode": CovenantCode,
        "CustomerCode": CustomerCode,
        "EnterpriseId": EnterpriseId,
        "Peoples": Peoples,
        "FlagOrigin": FlagOrigin,
        "DeliveryControl": DeliveryControl,
        "SaleRequestId": SaleRequestId,
      };

  factory SaleRequestModel.fromEntity(SaleRequestEntity entity) =>
      SaleRequestModel(
        Products:
            entity.Products.map((e) => ProductModel.fromEntity(e)).toList(),
        DateOfCreation: entity.DateOfCreation,
        DateHourOfCreation: entity.DateHourOfCreation,
        RequestType: entity.RequestType,
        SellerCode: entity.SellerCode,
        FlagStatus: entity.FlagStatus,
        Comments: entity.Comments,
        PersonalizedCode: entity.PersonalizedCode,
        IsCancelled: entity.IsCancelled,
        IsUsing: entity.IsUsing,
        TotalLiquid: entity.TotalLiquid,
        CovenantCode: entity.CovenantCode,
        CustomerCode: entity.CustomerCode,
        EnterpriseId: entity.EnterpriseId,
        Peoples: entity.Peoples,
        FlagOrigin: entity.FlagOrigin,
        DeliveryControl: entity.DeliveryControl,
        SaleRequestId: entity.SaleRequestId,
      );

  SaleRequestEntity toEntity() => SaleRequestEntity(
        Products: Products.map((e) => e.toEntity()).toList(),
        DateOfCreation: DateOfCreation,
        DateHourOfCreation: DateHourOfCreation,
        RequestType: RequestType,
        SellerCode: SellerCode,
        FlagStatus: FlagStatus,
        Comments: Comments,
        PersonalizedCode: PersonalizedCode,
        IsCancelled: IsCancelled,
        IsUsing: IsUsing,
        TotalLiquid: TotalLiquid,
        CovenantCode: CovenantCode,
        CustomerCode: CustomerCode,
        EnterpriseId: EnterpriseId,
        Peoples: Peoples,
        FlagOrigin: FlagOrigin,
        DeliveryControl: DeliveryControl,
        SaleRequestId: SaleRequestId,
      );
}
