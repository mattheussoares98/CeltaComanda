// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class ProductCompositionViewModel extends Equatable {
  final String? ProductCompositionId;
  final String? EnterpriseId;
  final String? InternalCodeOnERPCodeFather;
  final String? InternalCodeOnERPCodeChild;
  final String? PluChild;
  final String? ChildName;
  final String? Quantity;
  final String? SalePrice;
  final String? OfferPrice;
  final String? IncrementValue;
  final String? IsOptionalItem;
  final String? ProductOptions;
  final List<ProductCompositionViewModel>? childs;
  int? indexOfSelectedChild;
  String? commentFather;

  ProductCompositionViewModel({
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
    required this.ProductOptions,
    this.indexOfSelectedChild,
    this.childs,
    this.commentFather,
  });

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
        ProductOptions,
        childs,
        indexOfSelectedChild,
        childs,
        commentFather,
      ];

  factory ProductCompositionViewModel.fromEntity(
          ProductCompositionEntity entity) =>
      ProductCompositionViewModel(
        ProductCompositionId: entity.ProductCompositionId.toString(),
        EnterpriseId: entity.EnterpriseId.toString(),
        InternalCodeOnERPCodeFather:
            entity.InternalCodeOnERPCodeFather.toString(),
        InternalCodeOnERPCodeChild:
            entity.InternalCodeOnERPCodeChild.toString(),
        PluChild: entity.PluChild.toString(),
        ChildName: entity.ChildName.toString(),
        Quantity: entity.Quantity?.toDouble().toString(),
        SalePrice: entity.SalePrice?.toDouble().toString(),
        OfferPrice: entity.OfferPrice?.toDouble().toString(),
        IncrementValue: entity.IncrementValue?.toDouble().toString(),
        IsOptionalItem: entity.IsOptionalItem.toString(),
        ProductOptions: entity.ProductOptions.toString(),
        commentFather: entity.comment,
      );

  factory ProductCompositionViewModel.fromEntityWithChilds(
    ProductCompositionEntity entity,
    List<ProductCompositionEntity> childs,
  ) =>
      ProductCompositionViewModel(
        ProductCompositionId: entity.ProductCompositionId.toString(),
        EnterpriseId: entity.EnterpriseId.toString(),
        InternalCodeOnERPCodeFather:
            entity.InternalCodeOnERPCodeFather.toString(),
        InternalCodeOnERPCodeChild:
            entity.InternalCodeOnERPCodeChild.toString(),
        PluChild: entity.PluChild.toString(),
        ChildName: entity.ChildName.toString(),
        Quantity: entity.Quantity?.toDouble().toString(),
        SalePrice: entity.SalePrice?.toDouble().toString(),
        OfferPrice: entity.OfferPrice?.toDouble().toString(),
        IncrementValue: entity.IncrementValue?.toDouble().toString(),
        IsOptionalItem: entity.IsOptionalItem.toString(),
        ProductOptions: entity.ProductOptions.toString(),
        childs: childs
            .map((element) => ProductCompositionViewModel.fromEntity(element))
            .toList(),
      );

  ProductCompositionEntity toEntity() => ProductCompositionEntity(
        ProductCompositionId: int.tryParse(ProductCompositionId.toString()),
        EnterpriseId: int.tryParse(EnterpriseId.toString()),
        InternalCodeOnERPCodeFather:
            int.tryParse(InternalCodeOnERPCodeFather.toString()),
        InternalCodeOnERPCodeChild:
            int.tryParse(InternalCodeOnERPCodeChild.toString()),
        PluChild: PluChild,
        ChildName: ChildName,
        Quantity: double.tryParse(Quantity.toString()),
        SalePrice: double.tryParse(SalePrice.toString()),
        OfferPrice: double.tryParse(OfferPrice.toString()),
        IncrementValue: double.tryParse(IncrementValue.toString()),
        IsOptionalItem: bool.tryParse(IsOptionalItem.toString()),
        ProductOptions: ProductOptions,
        comment: commentFather,
      );

  Map toJson() => {
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
        "ProductOptions": ProductOptions,
        "childs": childs,
        "indexOfSelectedChild": indexOfSelectedChild,
        "commentFather": commentFather,
      };

  factory ProductCompositionViewModel.fromJson(Map json) =>
      ProductCompositionViewModel(
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
        ProductOptions: json["ProductOptions"],
        indexOfSelectedChild: json["indexOfSelectedChild"],
        childs: json["childs"]?.map<ProductCompositionViewModel>(
                    (element) => ProductCompositionViewModel.fromJson(element))
                .toList(),
        commentFather: json["commentFather"],
      );
}
