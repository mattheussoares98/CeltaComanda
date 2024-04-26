// ignore_for_file: non_constant_identifier_names

import 'package:clean_celta_mobile/ui/pages/printed_products/view_models/printed_products_view_model.dart';

import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';

class PrintedViewModel extends Equatable {
  final List<PrintedProductsViewModel> Products;
  final String PersonalizedCode;
  final String TotalLiquid;
  final String DeliveryControl;
  final String? Comments;

  final String DateOfCreation;
  final String DateHourOfCreation;
  final String FlagStatus;
  final String EnterpriseId;
  final String? RequestType;
  final String IsCancelled;
  final String IsUsing;
  final String Peoples;
  final String SaleRequestId;
  final String FlagOrigin;

  @override
  List get props => [
        Products,
        PersonalizedCode,
        TotalLiquid,
        DeliveryControl,
        Comments,
      ];

  const PrintedViewModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.TotalLiquid,
    required this.DeliveryControl,
    this.Comments,
    required this.DateOfCreation,
    required this.DateHourOfCreation,
    required this.FlagStatus,
    required this.EnterpriseId,
    required this.RequestType,
    required this.IsCancelled,
    required this.IsUsing,
    required this.Peoples,
    required this.SaleRequestId,
    required this.FlagOrigin,
  });

  factory PrintedViewModel.fromEntity(PrintedEntity entity) => PrintedViewModel(
        Products:
            entity.Products.map((e) => PrintedProductsViewModel.fromEntity(e))
                .toList(),
        PersonalizedCode: entity.PersonalizedCode,
        Comments: entity.Comments,
        DateOfCreation: entity.DateOfCreation,
        DateHourOfCreation: entity.DateHourOfCreation,
        FlagStatus: entity.FlagStatus,
        RequestType: entity.RequestType,
        EnterpriseId: entity.EnterpriseId.toString(),
        TotalLiquid: entity.TotalLiquid.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        DeliveryControl: entity.DeliveryControl.toString(),
        IsCancelled: entity.IsCancelled.toString(),
        IsUsing: entity.IsUsing.toString(),
        Peoples: entity.Peoples.toString(),
        SaleRequestId: entity.SaleRequestId.toString(),
        FlagOrigin: entity.FlagOrigin.toString(),
      );
}
