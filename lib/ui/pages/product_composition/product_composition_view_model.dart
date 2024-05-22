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
              .toList());

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
      );
}
