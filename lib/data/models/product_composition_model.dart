

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';
import 'models.dart';

class ProductCompositionModel extends Equatable {
  final int? ProductCompositionId;
  final int? EnterpriseId;
  final int? InternalCodeOnERPCodeFather;
  final int? InternalCodeOnERPCodeChild;
  final String? PluChild;
  final String? ChildName;
  final double? Quantity;
  final double? SalePrice;
  final double? OfferPrice;
  final double? IncrementValue;
  final bool? IsOptionalItem;
  final bool? ProductIsFatherComposition;
  final dynamic ProductOptions;
  final String? comment;
  final int? indexOfSelectedChild;
  final ProductScheduleEntity? Schedule;

  const ProductCompositionModel({
    required this.ProductCompositionId,
    required this.EnterpriseId,
    required this.InternalCodeOnERPCodeFather,
    required this.InternalCodeOnERPCodeChild,
    required this.PluChild,
    required this.ChildName,
    required this.Quantity,
    required this.SalePrice,
    required this.OfferPrice,
    required this.IncrementValue,
    required this.IsOptionalItem,
    required this.ProductIsFatherComposition,
    required this.ProductOptions,
    required this.comment,
    required this.indexOfSelectedChild,
    required this.Schedule,
  });

  factory ProductCompositionModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys.toSet().containsAll(
      [
        "EnterpriseId",
        "InternalCodeOnERPCodeFather",
        "InternalCodeOnERPCodeChild",
        "PluChild",
        "ChildName",
        "IsOptionalItem",
        "ProductIsFatherComposition",
      ],
    )) {
      throw Exception();
    }

    return ProductCompositionModel(
      ProductCompositionId: json["ProductCompositionId"],
      EnterpriseId: json["EnterpriseId"],
      InternalCodeOnERPCodeFather: json["InternalCodeOnERPCodeFather"],
      InternalCodeOnERPCodeChild: json["InternalCodeOnERPCodeChild"],
      PluChild: json["PluChild"],
      ChildName: json["ChildName"],
      Quantity: json["Quantity"],
      SalePrice: json["SalePrice"],
      OfferPrice: json["OfferPrice"],
      IncrementValue: json["IncrementValue"],
      IsOptionalItem: json["IsOptionalItem"],
      ProductIsFatherComposition: json["ProductIsFatherComposition"],
      ProductOptions: json["ProductOptions"],
      comment: json["comment"],
      indexOfSelectedChild: json["indexOfSelectedChild"],
      Schedule: json["Schedule"] == null
          ? null
          : ProductScheduleModel.fromJson(json["Schedule"]).toEntity(),
    );
  }

  factory ProductCompositionModel.fromEntity(ProductCompositionEntity entity) {
    return ProductCompositionModel(
      ProductCompositionId: entity.ProductCompositionId,
      EnterpriseId: entity.EnterpriseId,
      InternalCodeOnERPCodeFather: entity.InternalCodeOnERPCodeFather,
      InternalCodeOnERPCodeChild: entity.InternalCodeOnERPCodeChild,
      PluChild: entity.PluChild,
      ChildName: entity.ChildName,
      Quantity: entity.Quantity,
      SalePrice: entity.SalePrice,
      OfferPrice: entity.OfferPrice,
      IncrementValue: entity.IncrementValue,
      IsOptionalItem: entity.IsOptionalItem,
      ProductIsFatherComposition: entity.ProductIsFatherComposition,
      ProductOptions: entity.ProductOptions,
      comment: entity.comment,
      indexOfSelectedChild: entity.indexOfSelectedChild,
      Schedule: entity.Schedule,
    );
  }

  Map<String, dynamic> toJson() => {
        "ProductCompositionId": ProductCompositionId,
        "EnterpriseId": EnterpriseId,
        "InternalCodeOnERPCodeFather": InternalCodeOnERPCodeFather,
        "InternalCodeOnERPCodeChild": InternalCodeOnERPCodeChild,
        "PluChild": PluChild,
        "ChildName": ChildName,
        "Quantity": Quantity,
        "SalePrice": SalePrice,
        "OfferPrice": OfferPrice,
        "IncrementValue": IncrementValue,
        "IsOptionalItem": IsOptionalItem,
        "ProductIsFatherComposition": ProductIsFatherComposition,
        "ProductOptions": ProductOptions,
        "comment": comment,
        "Schedule": Schedule,
      };

  ProductCompositionEntity toEntity() => ProductCompositionEntity(
        ProductCompositionId: ProductCompositionId,
        EnterpriseId: EnterpriseId,
        InternalCodeOnERPCodeFather: InternalCodeOnERPCodeFather,
        InternalCodeOnERPCodeChild: InternalCodeOnERPCodeChild,
        PluChild: PluChild,
        ChildName: ChildName,
        Quantity: Quantity,
        SalePrice: SalePrice,
        OfferPrice: OfferPrice,
        IncrementValue: IncrementValue,
        IsOptionalItem: IsOptionalItem,
        ProductIsFatherComposition: ProductIsFatherComposition,
        ProductOptions: ProductOptions,
        comment: comment,
        indexOfSelectedChild: indexOfSelectedChild,
        Schedule: Schedule,
      );

  @override
  List<Object?> get props => [
        ProductCompositionId,
        EnterpriseId,
        InternalCodeOnERPCodeFather,
        InternalCodeOnERPCodeChild,
        PluChild,
        ChildName,
        Quantity,
        SalePrice,
        OfferPrice,
        IncrementValue,
        IsOptionalItem,
        ProductIsFatherComposition,
        ProductOptions,
        Schedule,
      ];
}
