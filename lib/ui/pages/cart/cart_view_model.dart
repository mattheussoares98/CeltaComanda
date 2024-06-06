// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';

class SaleRequestTempViewModel extends Equatable {
  final List<SaleRequestTempProductsViewModel> Products;
  final String PersonalizedCode;
  final String EnterpriseId;
  final String TotalLiquid;
  final String DeliveryControl;
  final String? Comments;
  final String SaleRequestTempId;

  @override
  List get props => [
        Products,
        PersonalizedCode,
        EnterpriseId,
        TotalLiquid,
        DeliveryControl,
        Comments,
        SaleRequestTempId,
      ];

  const SaleRequestTempViewModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    required this.SaleRequestTempId,
    this.Comments,
  });

  factory SaleRequestTempViewModel.fromEntity(SaleRequestTempEntity entity) =>
      SaleRequestTempViewModel(
        Products: entity.Products.map(
          (e) => SaleRequestTempProductsViewModel.fromEntity(e),
        ).toList(),
        PersonalizedCode: entity.PersonalizedCode,
        EnterpriseId: entity.EnterpriseId.toString(),
        TotalLiquid: entity.TotalLiquid.toStringAsFixed(2).toBrazilianNumber(),
        DeliveryControl: entity.DeliveryControl.toString(),
        Comments: entity.Comments,
        SaleRequestTempId: entity.SaleRequestTempId.toString(),
      );

  SaleRequestTempEntity toEntity() => SaleRequestTempEntity(
        Products: Products.map((e) => e.toEntity()).toList(),
        PersonalizedCode: PersonalizedCode,
        SaleRequestTempId: int.parse(SaleRequestTempId),
        EnterpriseId: int.parse(EnterpriseId),
        DeliveryControl: int.parse(DeliveryControl),
        TotalLiquid: TotalLiquid.toDouble(),
        Comments: Comments,
      );

  Map toJson() => {
        "Products": Products,
        "PersonalizedCode": PersonalizedCode,
        "SaleRequestTempId": SaleRequestTempId,
        "EnterpriseId": EnterpriseId,
        "DeliveryControl": DeliveryControl,
        "TotalLiquid": TotalLiquid,
        "Comments": Comments,
      };
}
