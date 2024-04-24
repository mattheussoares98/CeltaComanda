// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class SaleRequestPrintedProductsViewModel extends Equatable {
  final List<dynamic> Products;
  final String PersonalizedCode;
  final double TotalLiquid;
  final int DeliveryControl;
  final String? Comments;

  @override
  List get props => [
        Products,
        PersonalizedCode,
        TotalLiquid,
        DeliveryControl,
        Comments,
      ];

  const SaleRequestPrintedProductsViewModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
  });

  factory SaleRequestPrintedProductsViewModel.fromEntity(
          PrintedProductsEntity entity) =>
      SaleRequestPrintedProductsViewModel(
        Products: entity.Products,
        PersonalizedCode: entity.PersonalizedCode,
        TotalLiquid: entity.TotalLiquid,
        DeliveryControl: entity.DeliveryControl,
        Comments: entity.Comments,
      );
}
