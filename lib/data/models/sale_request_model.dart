

import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../domain/entities/entities.dart';

class SaleRequestModel extends Equatable {
  final List<SaleRequestProductModel>? Products;
  final String? DateOfCreation;
  final String? DateHourOfCreation;
  final String? RequestType;
  final int? SellerCode;
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
  final double? IncrementValue;
  final int? IncrementType; //1 == value && 2 == percentage

  const SaleRequestModel({
    this.Products,
    this.DateOfCreation,
    this.DateHourOfCreation,
    this.RequestType,
    this.SellerCode,
    this.FlagStatus,
    this.Comments,
    this.PersonalizedCode,
    this.IsCancelled,
    this.IsUsing,
    this.TotalLiquid,
    required this.CovenantCode,
    required this.CustomerCode,
    this.IncrementValue,
    this.IncrementType,
    this.EnterpriseId,
    this.Peoples,
    this.FlagOrigin,
    this.DeliveryControl,
    this.SaleRequestId,
  });

  @override
  List<Object?> get props => [
        Products,
        DateOfCreation,
        DateHourOfCreation,
        RequestType,
        SellerCode,
        FlagStatus,
        Comments,
        PersonalizedCode,
        IsCancelled,
        IsUsing,
        TotalLiquid,
        CovenantCode,
        CustomerCode,
        EnterpriseId,
        Peoples,
        FlagOrigin,
        DeliveryControl,
        SaleRequestId,
        IncrementValue,
        IncrementType,
      ];

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
      IsUsing: false,
      TotalLiquid: data["TotalLiquid"],
      CovenantCode: data["CovenantCode"],
      CustomerCode: data["CustomerCode"],
      EnterpriseId: data["EnterpriseId"],
      Peoples: data["Peoples"],
      FlagOrigin: data["FlagOrigin"],
      DeliveryControl: data["DeliveryControl"],
      SaleRequestId: data["SaleRequestId"],
      IncrementValue: data["IncrementValue"],
      IncrementType: data["IncrementType"],
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
        "IncrementValue": IncrementValue,
        "IncrementType": IncrementType,
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
        IncrementValue: entity.IncrementValue,
        IncrementType: entity.IncrementType,
      );
}
