import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class SaleRequestProductModel extends Equatable {
  final String? SaleMovementProductCompositionId;
  final String? ProductPriceLookUpCode;
  final String? QuantityString;
  final String? Comments;
  final String? DateHourOfCreation;
  final bool? IsCancelled;
  final bool? IsDelivered;
  final bool? IsPrinted;
  final int? SaleRequestProductId;
  final int? UserId;
  final int? UserIdOfCancellation;
  final int? ProductionStatus;
  final int? ProductInternalCodeOnErp;
  final int? SaleRequestId;
  final bool? ProductIsFatherComposition;
  final double? Value;
  final double? Quantity;
  final double? TotalLiquid;
  final ProductModel? product;

  const SaleRequestProductModel({
    required this.SaleMovementProductCompositionId,
    required this.ProductPriceLookUpCode,
    required this.QuantityString,
    required this.Comments,
    required this.DateHourOfCreation,
    required this.IsCancelled,
    required this.IsDelivered,
    required this.IsPrinted,
    required this.SaleRequestProductId,
    required this.UserId,
    required this.UserIdOfCancellation,
    required this.ProductionStatus,
    required this.ProductInternalCodeOnErp,
    required this.SaleRequestId,
    required this.ProductIsFatherComposition,
    required this.Value,
    required this.Quantity,
    required this.TotalLiquid,
    required this.product,
  });

  @override
  List<Object?> get props => [
        SaleMovementProductCompositionId,
        ProductPriceLookUpCode,
        QuantityString,
        Comments,
        DateHourOfCreation,
        IsCancelled,
        IsDelivered,
        IsPrinted,
        SaleRequestProductId,
        UserId,
        UserIdOfCancellation,
        ProductionStatus,
        ProductInternalCodeOnErp,
        SaleRequestId,
        ProductIsFatherComposition,
        Value,
        Quantity,
        TotalLiquid,
        product,
      ];

  factory SaleRequestProductModel.fromJson(Map json) => SaleRequestProductModel(
        SaleMovementProductCompositionId:
            json["SaleMovementProductCompositionId"],
        ProductPriceLookUpCode: json["ProductPriceLookUpCode"],
        QuantityString: json["QuantityString"],
        Comments: json["Comments"],
        DateHourOfCreation: json["DateHourOfCreation"],
        IsCancelled: json["IsCancelled"],
        IsDelivered: json["IsDelivered"],
        IsPrinted: json["IsPrinted"],
        SaleRequestProductId: json["SaleRequestProductId"],
        UserId: json["UserId"],
        UserIdOfCancellation: json["UserIdOfCancellation"],
        ProductionStatus: json["ProductionStatus"],
        ProductInternalCodeOnErp: json["ProductInternalCodeOnErp"],
        SaleRequestId: json["SaleRequestId"],
        ProductIsFatherComposition: json["ProductIsFatherComposition"] == 1,
        Value: json["Value"],
        Quantity: json["Quantity"],
        TotalLiquid: json["TotalLiquid"],
        product: ProductModel.fromJson(json["Product"]),
      );

  factory SaleRequestProductModel.fromEntity(SaleRequestProductEntity entity) =>
      SaleRequestProductModel(
        SaleMovementProductCompositionId:
            entity.SaleMovementProductCompositionId?.toString(),
        ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
        QuantityString: entity.QuantityString,
        Comments: entity.Comments,
        DateHourOfCreation: entity.DateHourOfCreation,
        IsCancelled: entity.IsCancelled,
        IsDelivered: entity.IsDelivered,
        IsPrinted: entity.IsPrinted,
        SaleRequestProductId: entity.SaleRequestProductId,
        UserId: entity.UserId,
        UserIdOfCancellation: entity.UserIdOfCancellation,
        ProductionStatus: entity.ProductionStatus,
        ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp,
        SaleRequestId: entity.SaleRequestId,
        ProductIsFatherComposition: entity.ProductIsFatherComposition,
        Value: entity.Value,
        Quantity: entity.Quantity,
        TotalLiquid: entity.TotalLiquid,
        product: entity.Product != null
            ? ProductModel.fromEntity(entity.Product!)
            : null,
      );

  Map<String, dynamic> toJson() => {
        "SaleMovementProductCompositionId": SaleMovementProductCompositionId,
        "ProductPriceLookUpCode": ProductPriceLookUpCode,
        "QuantityString": QuantityString,
        "Comments": Comments,
        "DateHourOfCreation": DateHourOfCreation,
        "IsCancelled": IsCancelled,
        "IsDelivered": IsDelivered,
        "IsPrinted": IsPrinted,
        "SaleRequestProductId": SaleRequestProductId,
        "UserId": UserId,
        "UserIdOfCancellation": UserIdOfCancellation,
        "ProductionStatus": ProductionStatus,
        "ProductInternalCodeOnErp": ProductInternalCodeOnErp,
        "SaleRequestId": SaleRequestId,
        "ProductIsFatherComposition":
            ProductIsFatherComposition == true ? 1 : 0,
        "Value": Value,
        "Quantity": Quantity,
        "TotalLiquid": TotalLiquid,
        "Product": product?.toJson(),
      };
}
