// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';
import '../../../../ui/helpers/helpers.dart';
import '../../../../ui/pages/pages.dart';

class PrintedProductsViewModel extends Equatable {
  final ProductsViewModel Product;
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
  final String ProductIsFatherComposition;
  final List<PrintedProductsViewModel> childs;

  @override
  List get props => [
        Product,
        SaleRequestProductId,
        ProductPriceLookUpCode,
        Value,
        Quantity,
        QuantityString,
        UserId,
        DateHourOfCreation,
        IsCancelled,
        IsDelivered,
        IsPrinted,
        ProductionStatus,
        TotalLiquid,
        ProductInternalCodeOnErp,
        SaleRequestId,
        ProductIsFatherComposition,
        childs,
        Comments,
      ];

  const PrintedProductsViewModel({
    required this.Product,
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
    required this.ProductIsFatherComposition,
    required this.childs,
    this.Comments,
  });

  factory PrintedProductsViewModel.fromEntity(PrintedProductsEntity entity) =>
      PrintedProductsViewModel(
        Product: ProductsViewModel.fromEntity(entity.Product),
        ProductPriceLookUpCode: entity.ProductPriceLookUpCode,
        QuantityString: entity.QuantityString,
        Comments: entity.Comments,
        DateHourOfCreation: entity.DateHourOfCreation,
        SaleRequestProductId: entity.SaleRequestProductId.toString(),
        Value: entity.Value.toStringAsFixed(2).toBrazilianNumber(),
        Quantity: entity.Quantity.toStringAsFixed(2).toBrazilianNumber(),
        TotalLiquid: entity.TotalLiquid.toStringAsFixed(2).toBrazilianNumber(),
        UserId: entity.UserId.toString(),
        IsCancelled: entity.IsCancelled.toString(),
        IsDelivered: entity.IsDelivered.toString(),
        IsPrinted: entity.IsPrinted.toString(),
        ProductionStatus: entity.ProductionStatus.toString(),
        ProductInternalCodeOnErp: entity.ProductInternalCodeOnErp.toString(),
        SaleRequestId: entity.SaleRequestId.toString(),
        ProductIsFatherComposition:
            entity.ProductIsFatherComposition.toString(),
        childs: entity.childs
            .map((e) => PrintedProductsViewModel.fromEntity(e))
            .toList(),
      );
}
