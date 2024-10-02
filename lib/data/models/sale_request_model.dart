// ignore_for_file: non_constant_identifier_names

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';

class SaleRequestModel {
  final List<SaleRequestProductModel>? Products;
  final String? DateOfCreation;
  final String? DateHourOfCreation;
  final String? RequestType;
  final String? SellerCode;
  final String? FlagStatus;
  final String? Comments;
  final String? PersonalizedCode;
  final bool? IsCancelled;
  final bool? IsUsing;
  final double? TotalLiquid;
  final int? CovenantCode;
  final int? CustomerCode;
  final int? EnterpriseId;
  final int? Peoples;
  final int? FlagOrigin;
  final int? DeliveryControl;
  final int? SaleRequestId;

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

  factory SaleRequestModel.fromJson(Map data) {
    if (!data.keys.toSet().containsAll([
      "SaleRequestId",
      "PersonalizedCode",
    ])) {
      throw Exception();
    }

    return SaleRequestModel(
      Products: data["Products"]
          .map((e) => SaleRequestProductModel.fromJson(e))
          .toList()
          .cast<SaleRequestProductModel>(),
      DateOfCreation: data["DateOfCreation"],
      DateHourOfCreation: data["DateHourOfCreation"],
      RequestType: data["RequestType"],
      SellerCode: data["SellerCode"],
      FlagStatus: data["FlagStatus"],
      Comments: data["Comments"],
      PersonalizedCode: data["PersonalizedCode"],
      IsCancelled: data["IsCancelled"],
      IsUsing: data["IsUsing"],
      TotalLiquid: data["TotalLiquid"],
      CovenantCode: data["CovenantCode"],
      CustomerCode: data["CustomerCode"],
      EnterpriseId: data["EnterpriseId"],
      Peoples: data["Peoples"],
      FlagOrigin: data["FlagOrigin"],
      DeliveryControl: data["DeliveryControl"],
      SaleRequestId: data["SaleRequestId"],
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
            entity.Products.map((e) => SaleRequestProductModel.fromEntity(e))
                .toList(),
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
}
