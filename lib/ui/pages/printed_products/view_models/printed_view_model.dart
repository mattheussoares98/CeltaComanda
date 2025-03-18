import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../../ui/pages/pages.dart';

class PrintedViewModel extends Equatable {
  final List<PrintedProductsViewModel> Products;
  final String? PersonalizedCode;
  final String? TotalLiquid;
  final String? DeliveryControl;
  final String? Comments;
  final String? DateOfCreation;
  final String? DateHourOfCreation;
  final String? FlagStatus;
  final String? EnterpriseId;
  final String? RequestType;
  final String? IsCancelled;
  final String? IsUsing;
  final String? Peoples;
  final String? SaleRequestId;
  final String? FlagOrigin;
  final String? IncrementType;
  final String? IncrementValue;
  final String? CovenantCode;
  final String? CustomerCode;
  final String? SellerCode;

  @override
  List get props => [
        Products,
        PersonalizedCode,
        TotalLiquid,
        DeliveryControl,
        Comments,
        DateOfCreation,
        DateHourOfCreation,
        FlagStatus,
        EnterpriseId,
        RequestType,
        IsCancelled,
        IsUsing,
        Peoples,
        SaleRequestId,
        FlagOrigin,
        IncrementType,
        IncrementValue,
        CovenantCode,
        CustomerCode,
        SellerCode,
      ];

  const PrintedViewModel({
    required this.Products,
    required this.PersonalizedCode,
    required this.TotalLiquid,
    required this.DeliveryControl,
    required this.Comments,
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
    required this.IncrementType,
    required this.IncrementValue,
    required this.CovenantCode,
    required this.CustomerCode,
    required this.SellerCode,
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
        TotalLiquid: entity.TotalLiquid!.toStringAsFixed(2).toBrazilianNumber(),
        DeliveryControl: entity.DeliveryControl.toString(),
        IsCancelled: entity.IsCancelled.toString(),
        IsUsing: entity.IsUsing.toString(),
        Peoples: entity.Peoples.toString(),
        SaleRequestId: entity.SaleRequestId.toString(),
        FlagOrigin: entity.FlagOrigin.toString(),
        IncrementType: entity.IncrementType.toString(),
        IncrementValue: entity.IncrementValue.toString(),
        CovenantCode: entity.CovenantCode.toString(),
        CustomerCode: entity.CustomerCode.toString(),
        SellerCode: entity.SellerCode.toString(),
      );
}
