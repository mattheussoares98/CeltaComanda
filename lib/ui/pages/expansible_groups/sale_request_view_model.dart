// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../pages.dart';

class SaleRequestTempViewModel extends Equatable {
  final List<ProductsViewModel> Products;
  final String PersonalizedCode;
  final int EnterpriseId;
  final double TotalLiquid;
  final int DeliveryControl;
  final String? Comments;

  @override
  List get props => [
        Products,
        PersonalizedCode,
        EnterpriseId,
        TotalLiquid,
        DeliveryControl,
        Comments,
      ];

  const SaleRequestTempViewModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
  });

  factory SaleRequestTempViewModel.fromEntity(SaleRequestTempEntity entity) =>
      SaleRequestTempViewModel(
        Products: entity.Products.map((e) => ProductsViewModel(
              SaleRetailPraticed: e.SaleRetailPraticed.toString(),
              PackingAbbreviation: e.PackingAbbreviation,
              Name: e.Name,
              EanCode: e.EanCode.toString(),
              PriceLookupCode: e.PriceLookupCode,
              ProductsId: e.ProductsId,
            )).toList(),
        PersonalizedCode: entity.PersonalizedCode,
        EnterpriseId: entity.EnterpriseId,
        TotalLiquid: entity.TotalLiquid,
        DeliveryControl: entity.DeliveryControl,
        Comments: entity.Comments,
      );
}
