import 'package:equatable/equatable.dart';

import '../../../domain/entities/conc_sale_request/conc_sale_request.dart';

class ConcSaleRequestProductModel extends Equatable {
  final int? SaleRequestProductId;
  final int? InternalCodeOnERP;
  final String? ProductPlu;
  final String? EanCode;
  final double? Quantity;
  final int? UserId;
  final double? Value;
  final bool? IsCancelled;
  final int? UserIdOfCancellation;
  final bool? IsDelivered;
  final bool? IsPrinted;
  final String? Comments;
  final double? TotalLiquid;
  final int? SaleRequestId;
  final bool? ProductIsFatherComposition;
  final String? SaleRequestProductIdOfFather;
  final int? SaleRequestProductInternalCodeOnERP;
  final String? ProductName;
  final SaleBlockadeDiscountType? BlockadeDiscountType;
  final double? DiscountFromSaleOffer;
  final String? UserOfDiscount;
  final double? AveragedDiscount;
  final double? AveragedIncrement;
  final double? AveragedDeliveryTax;
  final double? SaleRetailPrice;
  final double? SaleRetailOffer;
  final double? WholeSalePrice;
  final double? WholeSaleOffer;
  final ConcSaleRequestProductModel? SaleRequestProducOfFatherComposition;
  final DateTime? DateHourOfCreation;
// final ModelSaleRequest SaleRequest ;

  const ConcSaleRequestProductModel({
    required this.SaleRequestProductId,
    required this.InternalCodeOnERP,
    required this.ProductPlu,
    required this.EanCode,
    required this.Quantity,
    required this.UserId,
    required this.Value,
    required this.IsCancelled,
    required this.UserIdOfCancellation,
    required this.IsDelivered,
    required this.IsPrinted,
    required this.Comments,
    required this.TotalLiquid,
    required this.SaleRequestId,
    required this.ProductIsFatherComposition,
    required this.SaleRequestProductIdOfFather,
    required this.SaleRequestProductInternalCodeOnERP,
    required this.ProductName,
    required this.BlockadeDiscountType,
    required this.DiscountFromSaleOffer,
    required this.UserOfDiscount,
    required this.AveragedDiscount,
    required this.AveragedIncrement,
    required this.AveragedDeliveryTax,
    required this.SaleRetailPrice,
    required this.SaleRetailOffer,
    required this.WholeSalePrice,
    required this.WholeSaleOffer,
    required this.SaleRequestProducOfFatherComposition,
    required this.DateHourOfCreation,
  });

  @override
  List<Object?> get props => [
        SaleRequestProductId,
        InternalCodeOnERP,
        ProductPlu,
        EanCode,
        Quantity,
        UserId,
        Value,
        IsCancelled,
        UserIdOfCancellation,
        IsDelivered,
        IsPrinted,
        Comments,
        TotalLiquid,
        SaleRequestId,
        ProductIsFatherComposition,
        SaleRequestProductIdOfFather,
        SaleRequestProductInternalCodeOnERP,
        ProductName,
        BlockadeDiscountType,
        DiscountFromSaleOffer,
        UserOfDiscount,
        AveragedDiscount,
        AveragedIncrement,
        AveragedDeliveryTax,
        SaleRetailPrice,
        SaleRetailOffer,
        WholeSalePrice,
        WholeSaleOffer,
        DateHourOfCreation,
      ];

  factory ConcSaleRequestProductModel.fromEntity(
          ConcSaleRequestProductEntity entity) =>
      ConcSaleRequestProductModel(
        SaleRequestProductId: entity.SaleRequestProductId,
        InternalCodeOnERP: entity.InternalCodeOnERP,
        ProductPlu: entity.ProductPlu,
        EanCode: entity.EanCode,
        Quantity: entity.Quantity,
        UserId: entity.UserId,
        Value: entity.Value,
        IsCancelled: entity.IsCancelled,
        UserIdOfCancellation: entity.UserIdOfCancellation,
        IsDelivered: entity.IsDelivered,
        IsPrinted: entity.IsPrinted,
        Comments: entity.Comments,
        TotalLiquid: entity.TotalLiquid,
        SaleRequestId: entity.SaleRequestId,
        ProductIsFatherComposition: entity.ProductIsFatherComposition,
        SaleRequestProductIdOfFather: entity.SaleRequestProductIdOfFather,
        SaleRequestProductInternalCodeOnERP:
            entity.SaleRequestProductInternalCodeOnERP,
        ProductName: entity.ProductName,
        BlockadeDiscountType: entity.BlockadeDiscountType,
        DiscountFromSaleOffer: entity.DiscountFromSaleOffer,
        UserOfDiscount: entity.UserOfDiscount,
        AveragedDiscount: entity.AveragedDiscount,
        AveragedIncrement: entity.AveragedIncrement,
        AveragedDeliveryTax: entity.AveragedDeliveryTax,
        SaleRetailPrice: entity.SaleRetailPrice,
        SaleRetailOffer: entity.SaleRetailOffer,
        WholeSalePrice: entity.WholeSalePrice,
        WholeSaleOffer: entity.WholeSaleOffer,
        DateHourOfCreation: entity.DateHourOfCreation,
        SaleRequestProducOfFatherComposition:
            entity.SaleRequestProducOfFatherComposition == null
                ? null
                : ConcSaleRequestProductModel.fromEntity(
                    entity.SaleRequestProducOfFatherComposition!),
      );

  ConcSaleRequestProductEntity toEntity() => ConcSaleRequestProductEntity(
        SaleRequestProductId: SaleRequestProductId,
        InternalCodeOnERP: InternalCodeOnERP,
        ProductPlu: ProductPlu,
        EanCode: EanCode,
        Quantity: Quantity,
        UserId: UserId,
        Value: Value,
        IsCancelled: IsCancelled,
        UserIdOfCancellation: UserIdOfCancellation,
        IsDelivered: IsDelivered,
        IsPrinted: IsPrinted,
        Comments: Comments,
        TotalLiquid: TotalLiquid,
        SaleRequestId: SaleRequestId,
        ProductIsFatherComposition: ProductIsFatherComposition,
        SaleRequestProductIdOfFather: SaleRequestProductIdOfFather,
        SaleRequestProductInternalCodeOnERP:
            SaleRequestProductInternalCodeOnERP,
        ProductName: ProductName,
        BlockadeDiscountType: BlockadeDiscountType,
        DiscountFromSaleOffer: DiscountFromSaleOffer,
        UserOfDiscount: UserOfDiscount,
        AveragedDiscount: AveragedDiscount,
        AveragedIncrement: AveragedIncrement,
        AveragedDeliveryTax: AveragedDeliveryTax,
        SaleRetailPrice: SaleRetailPrice,
        SaleRetailOffer: SaleRetailOffer,
        WholeSalePrice: WholeSalePrice,
        WholeSaleOffer: WholeSaleOffer,
        DateHourOfCreation: DateHourOfCreation,
        SaleRequestProducOfFatherComposition:
            SaleRequestProducOfFatherComposition?.toEntity(),
      );

  factory ConcSaleRequestProductModel.fromJson(Map json) =>
      ConcSaleRequestProductModel(
        SaleRequestProductId: json['SaleRequestProductId'],
        InternalCodeOnERP: json['InternalCodeOnERP'],
        ProductPlu: json['ProductPlu'],
        EanCode: json['EanCode'],
        Quantity: json['Quantity'],
        UserId: json['UserId'],
        Value: json['Value'],
        IsCancelled: json['IsCancelled'],
        UserIdOfCancellation: json['UserIdOfCancellation'],
        IsDelivered: json['IsDelivered'],
        IsPrinted: json['IsPrinted'],
        Comments: json['Comments'],
        TotalLiquid: json['TotalLiquid'],
        SaleRequestId: json['SaleRequestId'],
        ProductIsFatherComposition: json['ProductIsFatherComposition'],
        SaleRequestProductIdOfFather: json['SaleRequestProductIdOfFather'],
        SaleRequestProductInternalCodeOnERP:
            json['SaleRequestProductInternalCodeOnERP'],
        ProductName: json['ProductName'],
        BlockadeDiscountType: SaleBlockadeDiscountType.values
            .firstWhere((e) => e.code == json['BlockadeDiscountType']),
        DiscountFromSaleOffer: json['DiscountFromSaleOffer'],
        UserOfDiscount: json['UserOfDiscount'],
        AveragedDiscount: json['AveragedDiscount'],
        AveragedIncrement: json['AveragedIncrement'],
        AveragedDeliveryTax: json['AveragedDeliveryTax'],
        SaleRetailPrice: json['SaleRetailPrice'],
        SaleRetailOffer: json['SaleRetailOffer'],
        WholeSalePrice: json['WholeSalePrice'],
        WholeSaleOffer: json['WholeSaleOffer'],
        SaleRequestProducOfFatherComposition:
            json['SaleRequestProducOfFatherComposition'],
        DateHourOfCreation: DateTime.tryParse(json['DateHourOfCreation'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "SaleRequestProductId": SaleRequestProductId,
        "InternalCodeOnERP": InternalCodeOnERP,
        "ProductPlu": ProductPlu,
        "EanCode": EanCode,
        "Quantity": Quantity,
        "UserId": UserId,
        "Value": Value,
        "IsCancelled": IsCancelled,
        "UserIdOfCancellation": UserIdOfCancellation,
        "IsDelivered": IsDelivered,
        "IsPrinted": IsPrinted,
        "Comments": Comments,
        "TotalLiquid": TotalLiquid,
        "SaleRequestId": SaleRequestId,
        "ProductIsFatherComposition": ProductIsFatherComposition,
        "SaleRequestProductIdOfFather": SaleRequestProductIdOfFather,
        "SaleRequestProductInternalCodeOnERP":
            SaleRequestProductInternalCodeOnERP,
        "ProductName": ProductName,
        "BlockadeDiscountType": BlockadeDiscountType?.code,
        "DiscountFromSaleOffer": DiscountFromSaleOffer,
        "UserOfDiscount": UserOfDiscount,
        "AveragedDiscount": AveragedDiscount,
        "AveragedIncrement": AveragedIncrement,
        "AveragedDeliveryTax": AveragedDeliveryTax,
        "SaleRetailPrice": SaleRetailPrice,
        "SaleRetailOffer": SaleRetailOffer,
        "WholeSalePrice": WholeSalePrice,
        "WholeSaleOffer": WholeSaleOffer,
        "SaleRequestProducOfFatherComposition":
            SaleRequestProducOfFatherComposition,
        "DateHourOfCreation": DateHourOfCreation?.toIso8601String(),
      };
}
