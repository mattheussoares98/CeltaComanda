// ignore_for_file: non_constant_identifier_names

import 'package:clean_celta_mobile/ui/pages/pages.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';

class PrintedProductsViewModel extends Equatable {
  final ProductsViewModel Products;
  final String SaleRequestProductId;
  final String ProductPriceLookUpCode;
  final String Value;
  final String Quantity;
  final String QuantityString;
  final String? Comments;
  final String UserId;
  final String DateHourOfCreation;
  final String IsCancelled;
  final String IsDelivered;
  final String IsPrinted;
  final String ProductionStatus;
  final String TotalLiquid;
  final String ProductInternalCodeOnErp;
  final String SaleRequestId;

  @override
  List get props => [];

  const PrintedProductsViewModel({
    required this.Products,
    required this.SaleRequestProductId,
    required this.ProductPriceLookUpCode,
    required this.Value,
    required this.Quantity,
    required this.QuantityString,
    required this.UserId,
    required this.DateHourOfCreation,
    required this.IsCancelled,
    required this.IsDelivered,
    required this.IsPrinted,
    required this.ProductionStatus,
    required this.TotalLiquid,
    required this.ProductInternalCodeOnErp,
    required this.SaleRequestId,
    this.Comments,
  });

  factory PrintedProductsViewModel.fromEntity(PrintedProductsEntity entity) =>
      PrintedProductsViewModel(
        Products: ProductsViewModel.fromEntity(entity.Product),
        ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
        QuantityString: entity.QuantityString,
        Comments: entity.Comments,
        DateHourOfCreation: entity.DateHourOfCreation,
        SaleRequestProductId: entity.SaleRequestProductId.toString(),
        Value: entity.Value.toStringAsFixed(2).replaceAll(RegExp(r'\.'), ','),
        Quantity:
            entity.Quantity.toStringAsFixed(2).replaceAll(RegExp(r'\.'), ','),
        TotalLiquid: entity.TotalLiquid.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.'), ','),
        UserId: entity.UserId.toString(),
        IsCancelled: entity.IsCancelled.toString(),
        IsDelivered: entity.IsDelivered.toString(),
        IsPrinted: entity.IsPrinted.toString(),
        ProductionStatus: entity.ProductionStatus.toString(),
        ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp.toString(),
        SaleRequestId: entity.SaleRequestId.toString(),
      );
}
