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
  final String? Peoples;
  final String? SellerCode;

  @override
  List get props => [
        Products,
        PersonalizedCode,
        EnterpriseId,
        TotalLiquid,
        DeliveryControl,
        Comments,
        SaleRequestTempId,
        Peoples,
        SellerCode,
      ];

  const SaleRequestTempViewModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.EnterpriseId,
    required this.TotalLiquid,
    required this.DeliveryControl,
    required this.SaleRequestTempId,
    required this.Comments,
    required this.Peoples,
    required this.SellerCode,
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
        Peoples: entity.Peoples?.toString(),
        SaleRequestTempId: entity.SaleRequestTempId.toString(),
        SellerCode: entity.SellerCode,
      );

  SaleRequestTempEntity toEntity() => SaleRequestTempEntity(
        Products: Products.map((e) => e.toEntity()).toList(),
        PersonalizedCode: PersonalizedCode,
        SaleRequestTempId: SaleRequestTempId.toInt(),
        EnterpriseId: EnterpriseId.toInt(),
        DeliveryControl: DeliveryControl.toInt(),
        TotalLiquid: TotalLiquid.toDouble(),
        Comments: Comments,
        Peoples: Peoples?.toInt(),
        SellerCode: SellerCode,
      );

  Map toJson() => {
        "Products": Products,
        "PersonalizedCode": PersonalizedCode,
        "SaleRequestTempId": SaleRequestTempId,
        "EnterpriseId": EnterpriseId,
        "DeliveryControl": DeliveryControl,
        "TotalLiquid": TotalLiquid,
        "Comments": Comments,
        "Peoples": Peoples,
        "SellerCode": SellerCode,
      };
}
