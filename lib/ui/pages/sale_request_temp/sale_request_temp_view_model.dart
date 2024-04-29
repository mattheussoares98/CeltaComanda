// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../pages.dart';

class SaleRequestTempViewModel extends Equatable {
  final List<SaleRequestTempProductsViewModel> Products;
  final String PersonalizedCode;
  final String EnterpriseId;
  final String TotalLiquid;
  final String DeliveryControl;
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
        Products: entity.Products.map(
          (e) => SaleRequestTempProductsViewModel.fromEntity(e),
        ).toList(),
        PersonalizedCode: entity.PersonalizedCode,
        EnterpriseId: entity.EnterpriseId.toString(),
        TotalLiquid: entity.TotalLiquid.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        DeliveryControl: entity.DeliveryControl.toString(),
        Comments: entity.Comments,
      );
}
