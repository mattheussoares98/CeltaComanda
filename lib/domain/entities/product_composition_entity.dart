

import 'package:equatable/equatable.dart';

import 'entities.dart';

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
  final ProductScheduleEntity? Schedule;
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
    required this.Schedule,
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
        Schedule,
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductCompositionEntity &&
        other.ProductCompositionId == ProductCompositionId &&
        other.EnterpriseId == EnterpriseId &&
        other.InternalCodeOnERPCodeFather == InternalCodeOnERPCodeFather &&
        other.InternalCodeOnERPCodeChild == InternalCodeOnERPCodeChild &&
        other.PluChild == PluChild &&
        other.ChildName == ChildName &&
        other.Quantity == Quantity &&
        other.SalePrice == SalePrice &&
        other.OfferPrice == OfferPrice &&
        other.IncrementValue == IncrementValue &&
        other.IsOptionalItem == IsOptionalItem &&
        other.ProductOptions == ProductOptions &&
        other.comment == comment &&
        other.indexOfSelectedChild == indexOfSelectedChild &&
        other.Schedule == Schedule &&
        listEquals(other.childsComposition, childsComposition);
  }

  @override
  int get hashCode {
    return Object.hash(
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
      comment,
      indexOfSelectedChild,
      childsComposition,
      Schedule,
    );
  }

  static bool listEquals(List? list1, List? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;
    if (list1.isEmpty && list2.isEmpty) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
