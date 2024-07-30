// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProductCompositionEntity extends Equatable {
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
  final dynamic ProductOptions;
  String? comment;
  List<ProductCompositionEntity>? childsComposition;
  int? indexOfSelectedChild;

  ProductCompositionEntity({
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
    required this.comment,
    required this.indexOfSelectedChild,
    this.childsComposition,
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
        childsComposition,
        indexOfSelectedChild,
      ];
}
